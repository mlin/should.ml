module Internal = struct
    type 'a p = 'a -> bool (* predicate *)
    class type ['elt,'ty] coll = object
        method value : 'ty
        method length : int
        method contains : 'elt -> bool
    end
    class type ['a,'b] call = object
        method func : ('a -> 'b)
        method arg: 'a
    end
    class type str = object
        method length : int
    end
    
    let exn_satisfying =
        let g pred x =
            try
                ignore ((x#func) (x#arg));
                false
            with exn -> pred exn
        in (g: (exn -> bool) -> ('a,'b) call -> bool)
    
    let rec make_should neg =
        let pred p x = if neg then not (p x) else p x in
        object
            method not = make_should (not neg)
            
            method satisfy : 'a . 'a p -> 'a p = fun usrpred -> pred usrpred
            
            (* equality *)
            method equal : 'a . 'a -> 'a p = fun y -> pred ((=) y)
            method physically = object
                method equal : 'a. 'a -> 'a p = fun y -> pred ((==) y)
            end
            
            (* comparisons *)
            method be = object
                method above: 'a. 'a -> 'a p = fun y -> pred ((<) y)
                method below: 'a. 'a -> 'a p = fun y -> pred ((>) y)
                method at = object
                    method least: 'a. 'a -> 'a p = fun y -> pred ((<=) y)
                    method most: 'a. 'a -> 'a p =  fun y -> pred ((>=) y)
                end
                method within: 'a. ('a*'a) -> 'a p = fun (y,z) -> pred (fun x -> x >= y && x <= z)
                method strictly = object
                    method within: 'a. ('a*'a) -> 'a p = fun (y,z) -> pred (fun x -> x > y && x < z)
                end
                
            (* floats *)
                method nan = pred (fun x -> match classify_float x with FP_nan -> true | _ -> false)
                method finite = pred (fun x -> match classify_float x with FP_zero | FP_subnormal | FP_normal -> true | _ -> false)
                
            (* strings *)
                method matching: Str.regexp -> ((string,string) coll) p = fun re -> pred (fun x -> Str.string_match re (x#value) 0)
                
            (* collections (lists, arrays, and strings) *)
                method empty: 'a 'b. (('a,'b) coll) p = pred (fun x-> x#length = 0)
            end
            method contain: 'a 'b. 'a -> (('a,'b) coll) p = fun y -> pred (fun x -> x#contains y)
            method have = object
                method length: 'a 'b. int -> (('a,'b) coll) p = fun y -> pred (fun x -> x#length = y)
            end
            
            (* function calls *)
            method raise = object
                method exn = object
                    method satisfying: 'a 'b. (exn -> bool) -> (('a,'b) call) p = fun exnpred -> pred (exn_satisfying exnpred)
                    method prefixed: 'a 'b. string -> (('a,'b) call) p = fun y ->
                        pred
                            (exn_satisfying
                                (fun exn ->
                                    try
                                        0 = Str.search_forward (Str.regexp_string y) (Printexc.to_string exn) 0
                                    with Not_found -> false))
                end
                method any = object
                    method exn: 'a 'b. (('a,'b) call) p = pred (exn_satisfying (fun _ -> true))
                end
            end
        end
end
;;

let should = Internal.make_should false
;;
let hould = should
;;
let shouldn't = Internal.make_should true
;;
let houldn't = shouldn't
;;
let ($) x test = assert (test x)
;;
let list x = object
    method value = x
    method length = List.length x
    method contains y = List.mem y x
end
;;
let array x = object
    method value = x
    method length = Array.length x
    method contains y = List.mem y (Array.to_list x)
end
;;
let string x = object
    method value = x
    method length = String.length x
    method contains y =
        try
            ignore (Str.search_forward (Str.regexp_string y) x 0); true
        with Not_found -> false
end
;;
let calling f x = object
    method func = f
    method arg = x
end
;;
