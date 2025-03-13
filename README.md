# ZIG_REGEX
PCRE2-POSIX  
  
  


Using "regex" from the new PCRE2-Posix standard<br>

https://github.com/mnemnion/mvzr  new regex form ZIG

example:<br>

Pay attention to the flag that is incumbent on you.<br>
/i ignore case<br>
/g global <br>
/m multiline <br>


```
const std = @import("std");

// tools regex
const reg = @import("match");

const allocatorPrint = std.heap.page_allocator;

pub fn main() !void {

const stdin = std.io.getStdIn().reader();
var buf : [3]u8 = undefined;
buf = [_]u8{0} ** 3;

  std.debug.print("Macth abc {} \r\n",.{reg.isMatch("p1","^[A-Z]{1,1}[a-zA-Z0-9]{0,}$/g")}) ;


  std.debug.print("Macth abc {} \r\n",.{reg.isMatch("p1","^[a-zA-Z]{1,1}[a-zA-Z0-9]{0,}$")}) ;

  std.debug.print("Macth digit {} \r\n",.{reg.isMatch(
  "423",
  "^[1-9]{1,1}?[0-9]{0,}$")}) ;

  std.debug.print("Macth tel fr{} \r\n",.{reg.isMatch(
  "+(33)6.12.34.56.78",
  "^[+]{1,1}[(]{0,1}[0-9]{1,3}[)]([0-9]{1,3}){1,1}([-. ]?[0-9]{2,3}){2,4}$")}) ;

  std.debug.print("Macth tel us{} \r\n",.{reg.isMatch(
  "+(001)456.123.789",
  "^[+]{1,1}[(]([0-9]{3,3})[)]([-. ]?[0-9]{3}){2,4}$")}) ;
  
  std.debug.print("Macth date fr{} \r\n",.{reg.isMatch(
  "12/10/1951",
  "^(0[1-9]|[12][0-9]|3[01])[\\/](0[1-9]|1[012])[\\/][0-9]{4,4}$")});


  std.debug.print("Macth date us{} \r\n",.{reg.isMatch(
  "10/12/1951",
  "^(0[1-9]|1[012])[\\/](0[1-9]|[12][0-9]|3[01])[\\/][0-9]{4,4}$")});

  std.debug.print("Macth date iso{} \r\n",.{reg.isMatch(
  "2003-02-25",
  "^([0-9]{4,4})[-](0[1-9]|1[012])[-](0[1-9]|[12][0-9]|3[01])$")});


  // https://stackoverflow.com/questions/201323/how-can-i-validate-an-email-address-using-a-regular-expression
  // chapitre RFC 6532 updates 5322 to allow and include full, clean UTF-8.

  std.debug.print("Macth Mail{} \r\n",.{reg.isMatch(
  "myname.myfirstname@gmail.com",
  "^([-!#-\'*+\\/-9=?A-Z^-~]{1,64}(\\.[-!#-\'*+\\/-9=?A-Z^-~]{1,64})*|\"([]!#-[^-~ \t]|(\\[\t -~]))+\")@[0-9A-Za-z]([0-9A-Za-z-]{0,61}[0-9A-Za-z])?(\\.[0-9A-Za-z]([0-9A-Za-z-]{0,61}[0-9A-Za-z])?)+$")});

  //oreilly
  std.debug.print("Macth Mail{} \r\n",.{reg.isMatch(
  "myname.myfirstname@gmail.com",
  "^[A-Z0-9_!#$%&'*+/=?`{|}~^.-]+@[A-Z0-9.-]+$")});




  var width :usize = 5;
  // unsigned digit
  std.debug.print("Macth digit unsigned{} \r\n",.{reg.isMatch(
  "123",
  std.fmt.allocPrint(allocatorPrint,"^[0-9]{s}{d}{s}$",.{"{1,",width,"}"},) catch unreachable)});

  // unsigned digit
  std.debug.print("Macth digit {} \r\n",.{reg.isMatch(
  "+12345",
  std.fmt.allocPrint(allocatorPrint,"^[+-][0-9]{s}{d}{s}$",.{"{1,",width,"}"},) catch unreachable)});

  
  // decimal unsigned  scal = 0
  std.debug.print("Macth decimal unsigned  scal = 0 {} \r\n",.{reg.isMatch(
  "12345",
  std.fmt.allocPrint(allocatorPrint,"^[0-9]{s}1,{d}{s}$",.{"{",width,"}"},) catch unreachable)});

  var scal :usize = 2;
  // decimal unsigned  scal > 0
  std.debug.print("Macth decimal unsigned  scal > 0 {} \r\n",.{reg.isMatch(
  "12345.02",
  std.fmt.allocPrint(allocatorPrint,
  "^[0-9]{s}1,{d}{s}[.][0-9]{s}{d}{s}$",.{"{",width,"}","{",scal,"}"}
  ) catch unreachable)});

  _= try stdin.readUntilDelimiterOrEof(buf[0..], '\n');
  
  // decimal signed   scal = 0
  std.debug.print("Macth decimal signed  scal = 0 {} \r\n",.{reg.isMatch(
  "+12345",
  std.fmt.allocPrint(allocatorPrint,"^[+-][0-9]{s}1,{d}{s}$",.{"{",width,"}"},) catch unreachable)});


  // decimal unsigned  scal > 0
  std.debug.print("Macth decimal signed  scal > 0 {} \r\n",.{reg.isMatch(
  "+12345.02",
  std.fmt.allocPrint(allocatorPrint,
  "^[+-][0-9]{s}1,{d}{s}[.][0-9]{s}{d}{s}$",.{"{",width,"}","{",scal,"}"}
  ) catch unreachable)});

  var i: usize = 0 ;
  while(i < 5000) : ( i += 1 ) {
  _=reg.isMatch(
  "1951-10-12",
  "^([0-9]{4,4})[-](0[1-9]|1[012])[-](0[1-9]|[12][0-9]|3[01])$");
  }


buf = [_]u8{0} ** 3;
  _= try stdin.readUntilDelimiterOrEof(buf[0..], '\n');
}

```
<BR />

*   •upgrade 2024-03-23.<BR /> 

*   •upgrade 2024-06-29.<BR /> 
&nbsp;&nbsp;&nbsp;&larr;&nbsp;zig version    0.13.0<BR />


*   •upgrade 2024-07-01.<BR /> 
&nbsp;&nbsp;&nbsp;&larr;&nbsp;Test Fluent and PCRE "C"   Zregex<BR /> 


*   •upgrade 2024-07-22.<BR /> 
&nbsp;&nbsp;&nbsp;&larr;&nbsp;Test MVZR and PCRE "C"   Zregex<BR /> 


*   •upgrade 2025-03-12.<BR /> 
&nbsp;&nbsp;&nbsp;&larr;&nbsp;zig version    0.14.0<BR />


*   •upgrade 2025-03-13.<BR /> 
&nbsp;&nbsp;&nbsp;&larr;&nbsp; update normalise and edit-code<BR />