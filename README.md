#ZIG_DECIMAL<br>
<br/>
processing decimal numbers with mpdecimal as a backdrop<br/>
<br/>
***I wrote this lib to free myself from arithmetic problems on large decimals***<br/>
<br/>
[https://speleotrove.com/decimal/](https://speleotrove.com/decimal/)<br>
<br/>
This part explains why we need it.<br/>
<br/>
Another source that inspired me and that joins what I think 1990 <br/>
<br/>
[https://github.com/dnotq/decNumber](https://github.com/dnotq/decNumber)<br/>
<br/>


# Table of Contents

- [Info](#info)

- [Notes](#notes)

- [Function](#function)

- [Usage](#usage) 

- [Avancement](#avancement)



##info
<br/>
&nbsp;&nbsp;&nbsp;  Communication structure for default common control decimal128 - 34 digits 
<br/>
## notes
<br/>
.<br>
&nbsp;Respects the SQL display alignment standard based on the trim()<br/>




## function
</br>

|Function      | Description                                          | Pub |trunc|bool|panic|
|--------------|------------------------------------------------------|-----|-----|----|-----|
|init          | Creates Decimal  (Entier ,  Scal)                    |  x  |     |    |  x  |
|deinit        | De-allocates the Decimal                             |  x  |     |    |     |
|              |                                                      |     |     |    |     |
|isNumber      | check the area is still 'NAN' and field INVALID      |  x  |     |  x |     |
|normalize     | normalize this conforms to the attributes            |  x  |     |    |     |
|              |                                                      |     |     |    |     |
|isOverflow    | Check if the number of integers is too high          |  x  |     |  x |     |
|setDcml       | give a value (text format) to '.number'              |  x  |  x  |    |  x  |
|set           | give a value (DCMLFX, f128)                          |  x  |  x  |    |     |
|zadd          | zadd(dst: *DCMLFX ,src: DCMLFX)                      |  x  |  x  |    |     |
|setZero       | forces the value 0 to setZeros(dst: *DCMLFX)         |  x  |     |    |     |
|isZeros       | checks if the value 0  isZeros(dst: DCMLFX)          |  x  |     |  x |     |
|round         | two-function round and truncate see finance...       |  x  |     |    |     |
|roundTo       | Copy data 'B' to 'A' rounded with 'A'.               |  x  |     |    |     |
|trunc         | function, truncate                                   |  x  |     |    |     |
|truncTo       | truncTo(dst: *DCMLFX, a : DCMLFX)                    |  x  |     |    |     |
|string        | Field formatting ex. 12345.321 field_init(8,3)       |  x  |  x  |    |     |
|editCodeFlt   | Field formatting and edit-code                       |  x  |  x  |    |     |
|strUFlt       | Field formatting and unsigned                        |  x  |  x  |    |     |
|editCodeInt   | Field formatting and edit-code                       |  x  |  x  |    |     |
|strUInt       | Field formatting and unsigned                        |  x  |  x  |    |     |
|              |                                                      |     |     |    |     |
|add           | a = a + b                                            |  x  |     |    |  x  |
|@"+"          | a = a + b                                            |  x  |     |    |  x  |
|addTo         | r = a + b                                            |  x  |     |    |  x  |
|sub           | a = a - b                                            |  x  |     |    |  x  |
|@"-"          | a = a - b                                            |  x  |     |    |  x  |
|subTo         | r = a - b                                            |  x  |     |    |  x  |
|mult          | a = a * b                                            |  x  |     |    |  x  |
|@"*"          | a = a * b                                            |  x  |     |    |  x  |
|mutlto        | r = a * b                                            |  x  |     |    |  x  |
|div           | a = a / b                                            |  x  |     |  x |  x  |
|@"/"          | c = a / b                                            |  x  |     |  x |  x  |
|divTo         | r = a / b                                            |  x  |     |  x |  x  |
|floor         | r = a                                                |  x  |     |    |  x  |
|ceil          | r = a                                                |  x  |     |    |  x  |
|rem           | r = a / b                                            |  x  |     |  x |  x  |
|getpercent    | r = a / b                                            |  x  |     |  x |  x  |
|percent       | r = a / b                                            |  x  |     |  x |  x  |
|rate          | total.rate(prix,nbritem,tax)                         |  x  |  x  |    |  x  |
|cmp           | compare a , b returns EQ LT GT ERR                   |  x  |     |    |  x  |
|eval          | evaluation d'expression                              |  x  |     |    |     |
|show          | show evaluation d'expression                         |  x  |     |    |     |
|              |                                                      |     |     |    |     |
|debugPrint    | small followed by '.number, entier, scal'            |  x  |     |    |     |
|              |                                                      |     |     |    |     |
|DcmlIterator  | Struct Iterator                                      |  .  |     |    |     |
|next          | next iterator Char(UTF8)                             |  .  |     |    |     |
|iterator      | Returns a DcmlIterator over the String               |  .  |     |    |     |
|isUTF8Byte    | Checks if byte is part of UTF-8 character            |  .  |     |    |     |
|getUTF8Size   | Returns the UTF-8 character's size                   |  .  |     |    |     |

  
  
## usage
</br/>

```
const std = @import("std");
const builtin = @import("builtin");

const dcml = @import("decimal").DCMLFX;


const stdout = std.io.getStdOut().writer();
const stdin = std.io.getStdIn().reader();

//=================================

pub const prix = struct {
  base      : dcml ,
  tax       : dcml ,
  htx       : dcml ,
  ttx       : dcml ,
  ttc       : dcml ,
  nbritem   : dcml ,
 

  // defined structure and set "0"
    pub fn init() prix {
        return prix {
            .base = dcml.init(13,2),
            .tax  = dcml.init(3,2),
            .htx  = dcml.init(20,2),
            .ttx = dcml.init(20,2),
            .ttc  = dcml.init(20,2),
            .nbritem  = dcml.init(15,0),
        };
    }

    pub fn deinitRecord( r :*prix) void {
        dcml.deinit(&r.base); 
        dcml.deinit(&r.tax);
        dcml.deinit(&r.htx);
        dcml.deinit(&r.ttc);
        dcml.deinit(&r.nbritem);
     }

};





pub fn main() !void {
stdout.writeAll("\x1b[2J") catch {};
stdout.writeAll("\x1b[3J") catch {};
stdout.print("\x1b[{d};{d}H", .{ 1, 1 }) catch {};


var vente  = prix.init ();

// prix moyenne voiture
vente.base.setDcml("45578.00") ;

// taxe 20%
vente.tax.setDcml("0.25") ;

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



// ----------------------
// test divers
// ----------------------


// other calcul
vente.htx.setZeros();
vente.ttx.setZeros();
vente.ttc.setZeros();

vente.base.setDcml("1.52") ;
vente.tax.setDcml("25") ;
vente.nbritem.setDcml("10") ;
std.debug.print("\r\n  Prices base fabrication    : {s}\r\n",.{vente.base.string()});
std.debug.print("\r\n  Tax                        : {s}\r\n",.{vente.tax.string()});
std.debug.print("\r\n  nombre de steack           : {s}\r\n",.{vente.nbritem.string()});


vente.htx.multTo(vente.base,vente.nbritem) ;
_=vente.ttx.percent(vente.htx, vente.tax);
vente.ttc.addTo(vente.htx, vente.ttx);
std.debug.print("\r\n  Total Price excluding tax  : {s}\r\n",.{vente.htx.string()});
std.debug.print("\r\n  Total Price           tax  : {s}\r\n",.{vente.ttx.string()});
std.debug.print("\r\n  Total Price included  tax  : {s}\r\n",.{vente.ttc.string()});

vente.htx.setZeros();
vente.ttc.setZeros();
vente.ttc.rate(vente.base,vente.nbritem,vente.tax) ;
std.debug.print("\r\n  Prices all taxes included {s}\r\n",.{vente.ttc.string()});


prix.deinitRecord(&vente);

std.debug.print("\r\n-----------------------------------\r\n",.{});



// test error
// dcml.debugContext();
// std.debug.print("\r\nzeros {}\r\n",.{vente.ttc.isZeros()});

var r = dcml.init(7,3) ;      // set 0 init default
var t = dcml.init(12,2) ;
var x = dcml.init(12,0) ;
var z = dcml.init(5,2) ;
var y = dcml.init(7,0) ;       // set 0 init default



// ------------------------------------------------------------------
// Management: calculation of the number of boxes to be delivered,
// taking into account business tolerances 
// ------------------------------------------------------------------

var boite = dcml.init( 7,0) ;

// Number of sheets per box
var feuille = dcml.init(4,0) ;
// Number of sheets off the press
var nbrfeuille = dcml.init(10,0);
// Number of sheets remaining less than one box
var rest = dcml.init(7,0);

// Tolerance below which a box cannot be added  
var tolerance = dcml.init(3,2);


var pourcentage = dcml.init(3,2);


boite.setDcml("0") ;
feuille.setDcml("2500") ;
nbrfeuille.setDcml("626500");
tolerance.setDcml("54.00");



// overflow
// rest.setDcml("1000");
// nbrfeuille.mult(rest);

std.debug.print("\r\n  divTo({s},{s})= boite:={s}\r\n",.{nbrfeuille.string(),feuille.string(),boite.string()});

rest.setZeros();pourcentage.setZeros();
_= boite.divTo(nbrfeuille,feuille) ;
_= rest.rem(nbrfeuille,feuille) ;
_= pourcentage.getpercent(rest,feuille) ;
std.debug.print("\r\n  percent({s},{s})= pourcentage:{s}\r\n",.{feuille.string(),rest.string(),pourcentage.string()});

// As the percentage is greater than 54%, 1 box is added to the delivery.
if( pourcentage.cmp(tolerance) == dcml.CMP.GT) {
    // rest.setDcml("1");
    boite.@"+"(1);
}
std.debug.print("\r\n  boite:{s}\r\n",.{boite.string()});


t.setDcml("3.55") ;
x.setDcml("3") ;

r.setDcml("3.55") ; r.floor() ;

std.debug.print("\r\n floor(t:{s})  r:{s}\r\n",.{t.string(),r.string()});

r.setDcml("3.55") ;r.ceil() ;
std.debug.print("\r\n ceil(t:{s})  r:{s}\r\n",.{t.string(),r.string()});


r.setZeros();
x.setZeros();
var t0 = r.divTo(t,x) ;
if (!t0) std.debug.print("Division by zeros",.{});
std.debug.print("\r\n  rem({s},{s})={s}\r\n",.{t.string(),x.string(),r.string()});

x.setDcml("2") ;
t.setZeros();
t0 = r.rem(t,x) ;
if (!t0) std.debug.print("Division by zeros",.{}); 
std.debug.print("\r\n  rem({s},{s})={s}\r\n",.{t.string(),x.string(),r.string()});



r.setDcml("12.650") ;
const repcmp = r.cmp(t) ;

std.debug.print("\r\n repcmp = dcml.cmp({s},{s})  = {}\r\n",.{r.string(),t.string(),repcmp});


r.setDcml("12.6509874") ;
std.debug.print("\r\n print setDcml(12.6509874)  (7.3) {s}\r\n",.{r.string()});



y.setDcml("12.6504") ;
std.debug.print("\r\n if (scale == 0 ) print setdcml(12.6504) (7,0)  {s}\r\n",.{y.string()});



t.setDcml("50.00"); 
r.setDcml("2.00") ;

z.multTo(t,r) ;
std.debug.print("\r\n t:{s} mult r:{s} =  {s}\r\n",.{ t.string(),r.string(),z.string()});

r.setZeros();
const t1 = t.div(r) ;
if (!t1) std.debug.print("Division by zeros",.{}); 
var c = dcml.init(7,3) ;      // set 0 init default
var b = dcml.init(12,2) ;





c.setDcml("12345.68521");
b.setZeros();

std.debug.print("\r\n c:{s}     b:{s}\r\n",.{c.string(), b.string()});
b.roundTo(c);
b.debugPrint("b.roundIndex(b)");
std.debug.print("control  b.roundIndex(c)  b:{s}  c:{s}; \r\n",.{b.string(),c.string()});


b.zadd(c);
std.debug.print("\r\n b.zadd(c);  b:{s}  c:{s}\r\n",.{b.string(),c.string()});

c.setDcml("12345.68541");
c.round();
std.debug.print("control  12345.68541 c.round()  c:{s}; \r\n",.{c.string()});

c.setDcml("-12345.68451");
c.round();
std.debug.print("control -12345.68451 c.round()  c:{s}; \r\n",.{c.string()});

c.setDcml("12345.68421");
c.round();
std.debug.print("control  12345.68421 c.round()  c:{s}; \r\n",.{c.string()});


c.setDcml("-12345.68781");
c.round();
std.debug.print("control  12345.68781 c.round()  c:{s}; \r\n",.{c.string()});

c.setDcml("12345.68781");
c.round();
std.debug.print("control  12345.68781 c.round()  c:{s}; \r\n",.{c.string()});


c.setDcml("12345.68541");
c.trunc();
std.debug.print("control  12345.68541 c.trunc()  c:{s}; \r\n",.{c.string()});

c.setDcml("12345.68451");
c.trunc();
std.debug.print("control  12345.68451 c.trunc()  c:{s}; \r\n",.{c.string()});

c.setDcml("12345.68421");
c.trunc();
std.debug.print("control  12345.68421 c.trunc()  c:{s}; \r\n",.{c.string()});


c.setDcml("12345.68781");
c.trunc();
std.debug.print("control  12345.68781 c.trunc()  c:{s}; \r\n",.{c.string()});
c.setDcml("-12345.68781");
c.trunc();
std.debug.print("control -12345.68781 c.trunc()  c:{s}; \r\n",.{c.string()});
std.debug.print("control  12345.68781 c.round()  c:{s}; \r\n",.{c.strUFlt()});

c.setZeros();

c.trunc();
std.debug.print("control 0.0          c.trunc()  c:{s}; \r\n",.{c.string()});


c.setDcml("12345.68781");
c.trunc();
std.debug.print("control  12345.68781 c.trunc()  c:{s}; \r\n",.{c.editCodeFlt("{c}{d:>7}.{d}")});
c.setDcml("-12345.68781");
c.trunc();
std.debug.print("control -12345.68781 c.trunc()  c:{s}; \r\n",.{c.editCodeInt("{c}{d:>7}")});
c.setDcml("-12345.68781");
c.round();
std.debug.print("control  12345.68781 c.round()  c:{s}; \r\n",.{c.editCodeFlt("{c}{d:>7}.{d}")});
c.setDcml("12345.68781");
c.round();
std.debug.print("control  12345.68781 c.round()  c:{s}; \r\n",.{c.editCodeFlt("{c}{d:>7}.{d}")});
std.debug.print("control  12345.68781 c.round()  c:{s}; \r\n",.{c.strUFlt()});


c.setZeros();
c.round();
std.debug.print("control  0.0         c.round()  c:{s}; \r\n",.{c.editCodeFlt("{c}{d:>7}.{d}")});
std.debug.print("control  0.0         c.round()  c:{s}; \r\n",.{c.strUFlt()});



r.setZeros();
const t2 =t.div(r) ;
if (!t2) std.debug.print("Division by zeros\n\r",.{});



var n = dcml.init(7,3) ;      // set 0 init default

n.@"+"(100.25);
std.debug.print("n.@+(100.25)  n:{s}; \r\n",.{n.string()});
n.@"-"(0.25);
std.debug.print("n.@-(0.25)    n:{s}; \r\n",.{n.string()});
n.@"*"(5);
std.debug.print("n.@*(5)       n:{s}; \r\n",.{n.string()});
_=n.@"/"(2);
std.debug.print("n.@/(2)       n:{s}; \r\n",.{n.string()});
_=n.@"/"(3);
std.debug.print("n.@/(3)       n:{s}; \r\n",.{n.string()});

pause("deinitDcml()");
dcml.deinitDcml();



    const e0 = dcml.Expr{
        .Div = .{
            .left  = &dcml.Expr{ .Val = 2 },
            .right = &dcml.Expr{ .Val = 0 },
        },
    };
    try dcml.show(&e0, &stdout);
    try stdout.print(" = {d}\n", .{dcml.eval(&e0)});

    var e1 = dcml.Expr{
        .Add = .{
            .left  = &dcml.Expr{ 
                .Div = .{
                    .left  = &dcml.Expr{ .Val = 2 },
                    .right = &dcml.Expr{ .Val = 0 },
                },
            },
            .right = &dcml.Expr{ .Val = 1 },
        }    
   
    };
    try dcml.show(&e1, &stdout);
    if (std.math.isNan(dcml.eval(&e1))) try stdout.print(" division par zeros\n", .{})
    else try stdout.print(" = {d} \n", .{dcml.eval(&e1)});

    e1 = dcml.Expr{
        .Add = .{
            .left  = &dcml.Expr{ 
                .Div = .{
                    .left  = &dcml.Expr{ .Val = -2 },
                    .right = &dcml.Expr{ .Val = 1 },
                },
            },
            .right = &dcml.Expr{ .Val = -1 },
        }    
   
    };
    try dcml.show(&e1, &stdout);
    if (std.math.isNan(dcml.eval(&e1))) try stdout.print(" division par zeros\n", .{})
    else try stdout.print(" = {d} \n", .{dcml.eval(&e1)});

pause("fin");
}
fn pause(text : [] const u8) void {
    std.debug.print("{s}\n",.{text});
    var buf : [3]u8  = [_]u8{0} ** 3;
	_= stdin.readUntilDelimiterOrEof(buf[0..], '\n') catch unreachable;

}
```



<br/><br/><br/>

## avancement
<br/>
&rarr; 2025-07-10 Standardization, based on AS400 principles
