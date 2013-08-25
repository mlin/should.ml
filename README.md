# [should.ml](https://github.com/mlin/should.js)
**Maintainer: [Mike Lin](https://blog.mlin.net/)**


This OCaml library allows one to write assertion statements in a
domain-specific language roughly resembling plain English, making unit
tests a bit nicer to read. No preprocessor or syntax extension is needed;
rather, the DSL is expressed through some mild abuse of objects and
overloaded operators.

This project is inspired by similar tools for various other languages,
especially [expect.js](https://github.com/LearnBoost/expect.js/) and its
predecessor [should.js](https://github.com/visionmedia/should.js/).

### Quick example

Read $ as the letter s, i.e. "$hould" as "should".

```
open Should

let int_test_case () =
    let x = 123 in begin
        x $hould # equal 123;
        x $hould # not # equal 0;
        
        x $hould # be # above 122;
        x $hould # be # at # most 124;
        
        x $hould # be # within (122,123);
        x $houldn't # be # within (1,3)
    end

let list_test_case () =
    let x = [1; 2; 3] in begin
        list x $houldn't # be # empty;
        list x $hould # have # length 3;
        list x $hould # contain 2;
        list x $hould # not # contain 0
    end

let fun_test_case () =
    let f = (function "" -> invalid_arg "f" | s -> String.lowercase s) in begin
        calling f "" $hould # raise # any # exn;
        calling f "" $hould # raise # exn # prefixed "Invalid_argument";
        calling f "foo" $houldn't # raise # any # exn
    end
```


### Reference

The assertions supported by should.ml are best shown by example. **Make sure to
`open Should` so that all the necessary names are available.**

#### Assertions on any type

```
x $hould # equal y
x $hould # not # equal y
x $hould # be # above y
x $hould # not # be # above y
x $hould # be # below y
x $hould # not # be # below y
```


Evidently, any assertion can be negated by saying `$hould # not` instead of just
`$hould`. One can also say `$houldn't`. **From this point on, the negated version
of each assertion will not be shown.**

```
x $hould # be # at # least y
x $hould # be # at # most y
x $hould # physically # equal y
x $hould # be # within (y,z)
x $hould # be # strictly # within (y,z)
```

"Physically" equal uses `(==)` instead of `(=)`. "Strictly within" compares
against the bounds using `(>)` and `(<)` rather than `(>=)` and `(<=)`.


Lastly, there's a generic assertion for a given predicate, with
`pred : 'a -> bool`:

```
x $hould # satisfy pred
```

#### Float

When `x : float`,
```
x $hould # be # nan
x $hould # be # finite
```

#### String

To access some string-specific assertions, prefix the statement with `string`.
When `x : string`,
```
string x $hould # be # empty
string x $hould # have # length y
string x $hould # contain "substring"
string x $hould # be # matching (Str.regexp "^The quick brown fox.*")
```

The `string` prefix is only used for these specific assertions, and cannot be
used with the generic equality and comparison assertions found above. Of course,
you _can_ perform those assertions on string values; just don't include the
`string` prefix. The same holds true for additional prefixes show below. This is
a minor wart in the DSL which may be possible to address with GADTs in the
future.

#### List and array

When `x : list`,
```
list x $hould # be # empty
list x $hould # have # length y
list x $hould # contain y
```

Similarly, when `x : array`,
```
array x $hould # be # empty
array x $hould # have # length y
array x $hould # contain y
```

Keep in mind that the generic equality and comparison operators, with no prefix
needed, are also frequently useful with collections: e.g.
`x $hould # equal [1; 2; 3]` or `List.length x $hould # be # above 3`.

It is possible to define additional container types for use with the `empty`,
`length`, and `contain` assertions. An example for `Hashtbl`, which is not
available by default:

```
let hashtbl x = object
    method value = x
    method length = Hashtbl.length x
    method contains y = Hashtbl.mem x y
end
```

One can then say `hashtbl x $hould # contain some_key`, etc.

#### Function calls

Often one just wants to use the equality and comparison operators on the result
of a function application, e.g. `f(x) $houldn't # be # nan`. A couple
interesting exception-related assertions are available with the `calling`
prefix:

```
calling f x $hould # raise # any # exn
calling f x $hould # raise # exn # prefixed "MyException"
calling f x $hould # raise # exn # satisfying pred
```

The `prefixed` assertion checks that the function call raises an exception, and
that the given string is a prefix of `Printexc.to_string` on the exception. This
usually starts with the exception constructor name, e.g. `"Failure("`. For even
greater precision, there's the `satisfying` assertion, where
`pred : exn -> bool`.
