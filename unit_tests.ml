open OUnit
open Should
;;

Printexc.record_backtrace true
;;

let fails f =
    let g () =
        try
            f ();
            false
        with _ -> true
    in assert (g ())
;;

let test_satisfy () = begin
    true $hould#satisfy (fun x -> x);
    false $hould # not # satisfy (fun x-> x);
    fails (fun () -> true $houldn't#satisfy (fun x -> x));
    fails (fun () -> false $hould # satisfy (fun x-> x))
end
;;

let test_equality () = begin
    0 $hould#equal 0;
    0 $hould#not#equal 1;
    fails (fun () -> 0 $hould#equal 1);
    fails (fun () -> 0 $houldn't#equal 0);
    
    let x = [0] in
    let y = [0] in begin
        x $hould#physically#equal x;
        x $hould#not#physically#equal y;
        fails (fun () -> x $hould#physically#equal y);
        fails (fun () -> x $hould#not#physically#equal x)
    end
end
;;

let test_comparisons () = begin
    (* above *)
    1 $hould#be#above 0;
    0 $hould#not#be#above 0;
    0 $houldn't#be#above 1;
    fails (fun () -> 0 $hould#be#above 0);
    fails (fun () -> 1 $houldn't#be#above 0);
    
    (* below *)
    0 $hould#be#below 1;
    0 $hould#not#be#below 0;
    1 $houldn't#be#below 0;
    fails (fun () -> 0 $hould#be#below 0);
    fails (fun () -> 0 $houldn't#be#below 1);
    
    (* at least *)
    1 $hould#be#at#least 0;
    1 $hould#be#at#least 1;
    0 $hould#not#be#at#least 1;
    0 $houldn't#be#at#least 1;
    fails (fun () -> 0 $hould#be#at#least 1);
    fails (fun () -> 1 $houldn't#be#at#least 0);
    
    (* at most *)
    0 $hould#be#at#most 1;
    1 $hould#be#at#most 1;
    1 $hould#not#be#at#most 0;
    1 $houldn't#be#at#most 0;
    fails (fun () -> 1 $hould#be#at#most 0);
    fails (fun () -> 0 $houldn't#be#at#most 1);
end
;;

let test_within () = begin
    0 $ shouldn't # be # within (1,3);
    1 $hould#be#within (1,3);
    2 $hould#be#within (1,3);
    3 $hould#be#within (1,3);
    4 $ should # not # be # within (1,3);

    fails (fun () -> 0 $hould # be # within (1,3));
    fails (fun () -> 1 $houldn't # be # within (1,3));
    fails (fun () -> 2 $houldn't # be # within (1,3));
    fails (fun () -> 3 $houldn't # be # within (1,3));
    fails (fun () -> 4 $hould # be # within (1,3));
    
    0 $ shouldn't # be # strictly # within (1,3);
    1 $hould#not#be#strictly#within (1,3);
    2 $hould#be#strictly#within (1,3);
    3 $hould#not#be#strictly#within (1,3);
    4 $ should # not # be # strictly # within (1,3);

    fails (fun () -> 0 $hould # be # strictly # within (1,3));
    fails (fun () -> 1 $hould # be # strictly # within (1,3));
    fails (fun () -> 2 $houldn't # be # strictly # within (1,3));
    fails (fun () -> 3 $hould # be # strictly # within (1,3));
    fails (fun () -> 4 $hould # be # strictly # within (1,3))
end
;;

let test_float () = begin
    nan $hould # be # nan;
    0. $houldn't # be # nan;
    neg_infinity $houldn't # be # nan;
    fails (fun () -> nan $houldn't # be # nan);
    fails (fun () -> 0. $hould # be # nan);
    fails (fun () -> neg_infinity $hould # be # nan);
    
    0. $hould # be # finite;
    nan $houldn't # be # finite;
    neg_infinity $houldn't # be # finite;
    infinity $houldn't # be # finite;
    fails (fun () -> 0. $houldn't # be # finite);
    fails (fun () -> nan $hould # be # finite);
    fails (fun () -> neg_infinity $hould # be # finite);
    fails (fun () -> infinity $hould # be # finite)
end
;;

let test_list () = begin
    [0] $hould # equal [0];
    [0] $houldn't # equal [1];
    fails (fun () -> [0] $hould # equal []);
    fails (fun () -> [] $houldn't # equal []);
    
    list [] $hould # be # empty;
    list [0] $houldn't # be # empty;
    fails (fun () -> list [1] $hould # be # empty);
    fails (fun () -> list [] $houldn't # be # empty);
    
    list [] $hould # have # length 0;
    list [1] $hould # have # length 1;
    list [1; 2] $hould # have # length 2;
    list [] $hould # not # have # length 1;
    fails (fun () -> list [] $hould # have # length 1);
    fails (fun () -> list [1; 2; 3] $houldn't # have # length 3);
    
    list [0] $hould # contain 0;
    list [1; 2; 3] $hould # contain 2;
    list [] $houldn't # contain 0;
    list [1; 2; 3] $houldn't # contain 0;
    fails (fun () -> list [] $hould # contain 0);
    fails (fun () -> list [0] $houldn't # contain 0);
    fails (fun () -> list [1; 2; 3] $hould # contain 0)
end
;;

let test_array () = begin
    [|0|] $hould # equal [|0|];
    [|0|] $houldn't # equal [|1|];
    fails (fun () -> [|0|] $hould # equal [||]);
    fails (fun () -> [||] $houldn't # equal [||]);
    
    array [||] $hould # be # empty;
    array [|0|] $houldn't # be # empty;
    fails (fun () -> array [|1|] $hould # be # empty);
    fails (fun () -> array [||] $houldn't # be # empty);
    
    array [||] $hould # have # length 0;
    array [|1|] $hould # have # length 1;
    array [|1; 2|] $hould # have # length 2;
    array [||] $hould # not # have # length 1;
    fails (fun () -> array [||] $hould # have # length 1);
    fails (fun () -> array [|1; 2; 3|] $houldn't # have # length 3);
    
    array [|0|] $hould # contain 0;
    array [|1; 2; 3|] $hould # contain 2;
    array [||] $houldn't # contain 0;
    array [|1; 2; 3|] $houldn't # contain 0;
    fails (fun () -> array [||] $hould # contain 0);
    fails (fun () -> array [|0|] $houldn't # contain 0);
    fails (fun () -> array [|1; 2; 3|] $hould # contain 0)
end
;;

let test_string () = begin
    "foo" $hould # equal "foo";
    "foo" $houldn't # equal "bar";
    fails (fun () -> "foo" $hould # equal "bar");
    fails (fun () -> "foo" $hould # not # equal "foo");
    
    string "" $hould # be # empty;
    string "foo" $houldn't # be # empty;
    fails (fun () -> string "" $houldn't # be # empty);
    fails (fun () -> string "foo" $hould # be # empty);
    
    string "" $hould # have # length 0;
    string "" $houldn't # have # length 1;
    string "foo" $hould # have # length 3;
    string "foo" $houldn't # have # length 1;
    fails (fun () -> string "" $hould # have # length 1);
    fails (fun () -> string "" $houldn't # have # length 0);
    fails (fun () -> string "foo" $hould # have # length 0);
    fails (fun () -> string "foo" $houldn't # have # length 3);
    
    string "foo" $hould # contain "foo";
    string "the quick brown fox" $hould # contain "quick";
    string "the quick brown fox" $hould # contain "wn fo";
    string "the quick brown fox" $hould # contain "";
    string "" $houldn't # contain "foo";
    string "the quick brown fox" $houldn't # contain "foo";
    fails (fun () -> string "foo" $hould # contain "bar");
    fails (fun () -> string "" $hould # contain "bar");
    fails (fun () -> string "the quick brown fox" $houldn't # contain "brown");
    
    string "foo" $hould # be # matching (Str.regexp "foo.*");
    string "the quick brown fox" $hould # be # matching (Str.regexp ".*fox$");
    string "foo" $houldn't # be # matching (Str.regexp "bar");
    fails (fun () -> string "foo" $hould # be # matching (Str.regexp "bar"))
end
;;

let nop () = ()
;;
let test_calling () = begin
    calling failwith "" $hould # raise # any # exn;
    calling nop () $houldn't # raise # any # exn;
    fails (fun () -> failwith "" $houldn't # raise # any # exn);
    fails (fun () -> calling nop () $hould # raise # any # exn);
    
    calling failwith "foo" $hould # raise # exn # satisfying (fun _ -> true);
    calling failwith "foo" $hould # raise # exn # satisfying
        (function Failure "foo" -> true | _ -> false);
    fails (fun () -> calling nop () $hould # raise # exn # satisfying (fun _ -> true));
    fails (fun () -> calling failwith "" $hould # raise # exn # satisfying (fun _ -> false));
    fails (fun () -> calling failwith "" $hould # raise # exn # satisfying
            (function Exit -> true | Failure "bar" -> true | _ -> false));
    
    calling failwith "" $hould # raise # exn # prefixed "Failure";
    fails (fun () -> calling failwith "" $hould # raise # exn # prefixed "Foo")
end
;;

let all_tests =
    "should tests" >::: [
        "satisfy" >:: test_satisfy;
        "equality" >:: test_equality;
        "comparisons" >:: test_comparisons;
        "within" >:: test_within;
        "float" >:: test_float;
        "list" >:: test_list;
        "array" >:: test_array;
        "string" >:: test_string;
        "calling" >:: test_calling
    ]
;;

run_test_tt_main all_tests
;;
