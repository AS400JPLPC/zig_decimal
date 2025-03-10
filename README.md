 zig_Decimal<br/>
<br/>
processing decimal numbers with mpdecimal as a backdrop<br/>
<br/>
***I wrote this lib to free myself from arithmetic problems on large decimals***<br/>
<br/>
[https://speleotrove.com/decimal/](https://speleotrove.com/decimal/)<br/>
<br/>
This part explains why we need it.<br/>
<br/>
Another source that inspired me and that joins what I think 1990 <br/>
<br/>
[https://github.com/dnotq/decNumber](https://github.com/dnotq/decNumber)<br/>
<br/>
---
<br/>
<br/>
&nbsp;&nbsp;[https://www.bytereef.org/mpdecimal/index.html](https://www.bytereef.org/mpdecimal/index.html)<br/>
Include("mpdecimal.h) view build;<br/>
<br/> you need to mount the mpdecimal package in your system<br/>
<br/>
installation with your package manager or download<br/>
<br/>
validated: by https://speleotrove.com/decimal/<<br/>
<br/>
official site thank you for making this standardization available<br/>
<br/>
---
<br/>
# Table of Contents

- [Info](#info)

- [Structure](#structure)

- [Notes](#notes)

- [Function](#function)

- [Usage](#usage) 

- [Avancement](#avancement)

<br/>
<br/>

## info
<br/>
je voulais  me libérer de logiciel externe a ZIG pour gérer les nombres fixe  de 34 digits pour le gestion d'entreprise <br/>
I wanted to free myself from ZIG external software to manage fixed 34-digit numbers for company management.<<br/>
<br/><br/><br/>

## structure

<br/>
&nbsp;&nbsp;&nbsp; MLFXDC &nbsp;includes 3 values<br/>
&nbsp;&nbsp;&nbsp;       number: mpdecimal structure [*c]<br/>
&nbsp;&nbsp;&nbsp;       integer: number of integers in front of the point<br/>
&nbsp;&nbsp;&nbsp;       scale: number of integers behind the point<br/>
<br/><br/><br/>

## notes

<br/>
&nbsp;Integers + decimals must not exceed the defined precision, e.g. 128 = 34 digits.,<br/>
&nbsp;All calculation functions e.g. add / sub ... are aligned with the field definition are truncated.<br/>
.<br/>
&nbsp;You need to use a wider working field, then round it with round(dcml A, dcml B) and render the rounding of A.scale.<br/>
Alternatively, you can truncate directly with the B.zadd(A) function.<br/>
.<br/>
&nbsp;Respects the SQL display alignment standard based on the trim()<br/>
<br/>

<br/>
&nbsp;For the function: isOverflow triggers an error BOOL, but does not handle it.
<br/>
Why not trigger a panic error with “isNumber” or “isOverflow” when this in the “string” function causes @panic,<br/>
is that it's possible to perform operations that are real, but whose result will not conform to the field definition,<br/>
you can avoid this by testing before “string”, “isNumber”,"isOverflow", "not-init", or use field deinit ,<br/>
you must either rethink the definition of your fields or revise your algorithm.<br/>
<br/>

If you use an uninitialized or already uninitialized field, this will trigger an @panic error.  --> CRTL
<br/>


```


SetDcml :
 if (!isNumber) triggers @panic
 if (!isOverflow) triggers @panic

zAdd: 
 if (!isOverflow) triggers @panic

String:
 if (!isOverflow) triggers @panic
 if NAN out-of-sequence it's up to you to test during EVAL output if there is a split and the return is nan

```


<br/><br/><br/>

## usage


```  

const std = @import("std");

const dcml = @import("decimal").DCMLFX;

pub const prix = struct {
  base      : dcml  ,
  tax       : dcml  ,
  htx       : dcml  ,
  ttx       : dcml  ,
  ttc       : dcml  ,
  nbritem   : dcml  ,


  // defined structure and set "0"
    pub fn init() prix {
        return prix {
            .base = dcml.init(13,2),
            .tax  = dcml.init(3,2),
            .htx  = dcml.init(20,2),
            .ttx  = dcml.init(20,2),
            .ttc  = dcml.init(20,2),
            .nbritem  = dcml.init(15,0),
        };
    }

};

pub fn main() !void {
const vente  = prix.init ();

// prix moyenne voiture
vente.base.setDcml("45578.00") ;

// taxe 20%
vente.tax.setDcml("1.25") ;

// number of cars sold by the group worldwide
vente.nbritem.setDcml("100000000000") ;


// Prices all taxes included
vente.ttc.rate(vente.base,vente.nbritem,vente.tax) ;

std.debug.print("\r\n  Prices base fabrication    : {s}\r\n",.{vente.base.string()});
std.debug.print("\r\n  Tax                        : {s}\r\n",.{vente.tax.string()});
std.debug.print("\r\n  nombre de voitures vendue  : {s}\r\n",.{vente.nbritem.string()});

// Total Price excluding tax
vente.htx.multTo(vente.base,vente.nbritem);

// Prices all taxes included
vente.ttc.rate(vente.base,vente.nbritem,vente.tax);

// Prices all total taxe
vente.ttx.subTo(vente.ttc, vente.htx);

std.debug.print("\r\n  Total Price excluding tax  : {s}\r\n",.{vente.htx.string()});
std.debug.print("\r\n  Total Price           tax  : {s}\r\n",.{vente.ttx.string()});
std.debug.print("\r\n  Total Price included  tax  : {s}\r\n",.{vente.ttc.string()});

dcml.deinitDcml()
}
  

```

<br/><br/><br/>



## function
<br/>

|Function      | Description                                          | Pub |trunc|bool|panic|ctrl|
|--------------|------------------------------------------------------|-----|-----|----|-----|----|
|init          | Creates Decimal  (Entier ,  Scal)                    |  x  |     |    |  x  |    |
|deinit        | De-allocates the Decimal                             |  x  |     |    |     |    |
|              |                                                      |     |     |    |     |    |
|isNumber      | check value is compliant '0-9 + - .'                 |  x  |     |  x |     |    |
|isOverflow    | Check if the number of integers is too high          |  x  |     |  x |     | x  |
|              |                                                      |     |     |    |     |    |
|normalize     | normalize this conforms to the attributes            |     |     |    |     |    |
|setDcml       | give a value (text format) to '.number'              |  x  |     |    |     | x  |
|set           | give a value (f128 format) to '.number'              |  x  |     |    |     | x  |
|zadd          | give a value (MLFXDC) to '.number'                   |  x  |     |    |     | x  |
|setZero       | forces the value 0 to '.number'                      |  x  |     |    |     | x  |
|isZeros       | checks if the value 0                                |  x  |     |    |     | x  |
|              |                                                      |     |     |    |     |    |
|round         | two-function round and truncate see finance...       |  x  |     |    |     | x  |
|roundTo       | Copy data 'B' to 'A' rounded with 'A'.               |  x  |     |    |     | x  |
|trunc         | function, truncate                                   |  x  |     |    |     | x  |
|string        | Field formatting ex. 12345.321 field_init(8,3)       |  x  |  x  |    |     | x  |
|              |                                                      |     |     |    |     |    |
|add           | a = a + b  a.add(b)                                  |  x  |     |    |     | x  |
|@"+"          | a = a + b  a.@"+"(b)  b =f128                        |  x  |     |    |     | x  |
|sub           | a = a - b  a.sub(b)                                  |  x  |     |    |     | x  |
|@"-"          | a = a + b  a.@"-"(b)  b =f128                        |  x  |     |    |     | x  |
|mult          | a = a * b  a.mult(b)                                 |  x  |     |    |     | x  |
|@"*"          | a = a + b  a.@"*"(b)  b =f128                        |  x  |     |    |     | x  |
|div           | a = a / b  if b = zeros raises an error              |  x  |     |  x |     | x  |
|@"/"          | a = a / b  a.@"/"(b)  b =f128                        |  x  |     |    |     | x  |
|addTo         | r = a + b  r.addto(a,b)                              |  x  |     |    |     | x  |
|subTo         | r = a - b                                            |  x  |     |    |     | x  |
|multTo        | r = a * b                                            |  x  |     |    |     | x  |
|divTo         | r = a / b  if b = zeros raises an error              |  x  |     |  x |     | x  |
|floor         | r = a                                                |  x  |     |    |     | x  |
|ceil          | r = a                                                |  x  |     |    |     | x  |
|rem           | r = a / b  if b = zeros raises an error              |  x  |     |  x |     | x  |
|getpercent    | retrieve percentage                                  |  x  |     |  x |     | x  |
|percent       | r = a / b * 100 if b = zeros raises an error         |  x  |     |  x |     | x  |
|rate          | total.rate(prix,nbritem,tax)                         |  x  |     |    |     | x  |
|cmp           | compare a , b returns EQ LT GT ERR                   |  x  |     |    |     | x  |
|              |                                                      |     |     |    |     |    |
|eval          | expression evaluation for complex calculations       |  x  |     |    |     |    |
|              |                                                      |     |     |    |     |    |
|debugPrint    | small followed by '.number, entier, scal'            |  x  |     |    |     |    |
|show          | display of evaluation expression                     |  x  |     |    |     |    |
|              |                                                      |     |     |    |     |    |
|DcmlIterator  | Struct Iterator                                      |  .  |     |    |     |    |
|next          | next iterator Char(UTF8)                             |  .  |     |    |     |    |
|iterator      | Returns a DcmlIterator over the String               |  .  |     |    |     |    |
|isUTF8Byte    | Checks if byte is part of UTF-8 character            |  .  |     |    |     |    |
|getIndex      | Returns the real index of a unicode                  |  .  |     |    |     |    |
|getUTF8Size   | Returns the UTF-8 character's size                   |  .  |     |    |     |    |
 



<br/><br/><br/>

## avancement

- 2025-03-06  I've finished checking and testing for memory leaks, and the functions have been reviewed and corrected.<br/>
I still have to test and normalize, I'm trying to get back to the AS400, same result and same possibility<br/>

- 2025-03-07  zig 0.14.0<br/>

- 2025-03-10 17:25 -> Resuming diagnostics with the better-understood 0.14.0 @src deciphering @panic<br