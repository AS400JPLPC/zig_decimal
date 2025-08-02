const std = @import("std");

const dcml = @import("decimal").DCMLFX;


pub const prix = struct {
  base      : dcml  ,
  tax       : dcml  ,
  htx       : dcml  ,
  ttc       : dcml  ,
  nbritem   : dcml  ,


  // defined structure and set "0"
    pub fn initRecord() prix {
      
        return prix {
            .base = dcml.init(13,2) ,      
            .tax  = dcml.init(3,2) ,
            .htx  = dcml.init(25,2) ,
            .ttc  = dcml.init(25,2) ,
            .nbritem  = dcml.init(15,0) ,
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
var out = std.fs.File.stdout().writerStreaming(&.{});
pub inline fn Print( comptime format: []const u8, args: anytype) void {
    out.interface.print(format, args) catch return;
 }
pub inline fn WriteAll( args: anytype) void {
    out.interface.writeAll(args) catch return;
 }
fn Pause(msg : [] const u8 ) void{

    Print("\nPause  {s}\r\n",.{msg});
    var stdin = std.fs.File.stdin();
    var buf: [16]u8 =  [_]u8{0} ** 16;
    var c  : usize = 0;
    while (c == 0) {
        c = stdin.read(&buf) catch unreachable;
    }
}


pub fn main() !void {
    WriteAll("\x1b[2J");
    WriteAll("\x1b[3J");
    Print("\x1b[{d};{d}H", .{ 1, 1 });


    var vente  = prix.initRecord();

    Pause("setp-1");

    // prix moyenne voiture
    vente.base.setDcml("150.85");

    // taxe 20%
    vente.tax.setDcml("1.25");

    // number of cars sold by the group worldwide
    vente.nbritem.setDcml("100");

    Pause("setp-2");


    // Total Price excluding tax
    vente.htx.multTo(vente.base,vente.nbritem);
    // Prices all taxes included
    vente.ttc.rate(vente.base,vente.nbritem,vente.tax);


    Pause(vente.base.string());
    Pause(vente.tax.string());
    Pause(vente.htx.string());
    Pause(vente.ttc.string());
    Pause(vente.nbritem.string());


    Pause("setp-3");


    var  i : usize = 0;
    while(i < 1000) :( i += 1) {
        vente.base.setDcml("45578.85");
    }

    Pause("setp-4");

    vente.base.setDcml("1000.00");
    Pause(vente.base.string());


    // count
    var count = dcml.init(5,0);
    count.setDcml("1");
    Pause(count.string());

    i = 0;
    while(i < 10) :( i += 1) {
        vente.base.add(count);
    }

    Pause(vente.base.string());

    Pause("setp-5");


    prix.deinitRecord(&vente);

    Pause("setp-6 deinit");

    dcml.deinitDcml();

    Pause("stop");
    count = dcml.init(5,0);
    count.setDcml("1");
    Pause(count.string());




    const e1 = dcml.Expr{ .Val = 100 };
    try dcml.show(&e1);
    Print(" = {d}\n", .{dcml.eval(&e1)});

    const e2 = dcml.Expr{ .Div = .{ .left = &dcml.Expr{ .Val = 10 }, .right = &dcml.Expr{ .Val = 2 } } };
    try dcml.show(&e2);
    Print(" = {d}\n", .{dcml.eval(&e2)});



    const e3 = dcml.Expr{
        .Div = .{
            .left = &dcml.Expr{
                .Mul = .{
                    .left = &dcml.Expr{ .Val = 5 },
                    .right = &dcml.Expr{ .Val = 4 },
                },
            },
            .right = &dcml.Expr{ .Val = 2 },
        },
    };
    try dcml.show(&e3);
    Print(" = {d}\n", .{dcml.eval(&e3)});


    const e4 = dcml.Expr{
        .Add = .{
            .left = &dcml.Expr{
                .Mul = .{
                    .left = &dcml.Expr{ .Val = 5 },
                    .right = &dcml.Expr{ .Val = 4 },
                },
            },
            .right = &dcml.Expr{
                .Sub = .{
                    .left = &dcml.Expr{ .Val = 100 },
                    .right = &dcml.Expr{
                        .Div = .{
                            .left = &dcml.Expr{ .Val = 12 },
                            .right = &dcml.Expr{ .Val = 4 },
                        },
                    },
                },
            },
        },
    };

    try dcml.show(&e4);
    Print(" = {d}\n", .{dcml.eval(&e4)});



    const e5 = dcml.Expr{ .Div = .{ .left = &dcml.Expr{ .Val = 100 }, .right = &dcml.Expr{ .Val = 0 } } };
    try dcml.show(&e5);
    Print(" = {d}\n", .{dcml.eval(&e5)});


    var t1 = dcml.init(5,1); t1.set(11.2);
    var t2 = dcml.init(5,0); t2.set(4);

    const e6 = dcml.Expr{
        .Mul = .{
            .left = &dcml.Expr{ .Val = t1.val },
            .right = &dcml.Expr{ .Val = t2.val },
        },
    };
    try dcml.show(&e6);
    Print(" = {d}\n", .{dcml.eval(&e6)});




}

