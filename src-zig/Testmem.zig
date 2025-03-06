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
const stdout = std.io.getStdOut().writer();
const stdin = std.io.getStdIn().reader();

pub fn main() !void {
    stdout.writeAll("\x1b[2J") catch {};
    stdout.writeAll("\x1b[3J") catch {};
    stdout.print("\x1b[{d};{d}H", .{ 1, 1 }) catch {};


    var vente  = prix.initRecord();

    pause("setp-1");

    // prix moyenne voiture
    vente.base.setDcml("150.85");

    // taxe 20%
    vente.tax.setDcml("1.25");

    // number of cars sold by the group worldwide
    vente.nbritem.setDcml("100");

    pause("setp-2");


    // Total Price excluding tax
    vente.htx.multTo(vente.base,vente.nbritem);
    // Prices all taxes included
    vente.ttc.rate(vente.base,vente.nbritem,vente.tax);


    pause(vente.base.string());
    pause(vente.tax.string());
    pause(vente.htx.string());
    pause(vente.ttc.string());
    pause(vente.nbritem.string());


    pause("setp-3");


    var  i : usize = 0;
    while(i < 1000) :( i += 1) {
        vente.base.setDcml("45578.85");
    }

    pause("setp-4");

    vente.base.setDcml("1000.00");
    pause(vente.base.string());


    // count
    var count = dcml.init(5,0);
    count.setDcml("1");
    pause(count.string());

    i = 0;
    while(i < 10) :( i += 1) {
        vente.base.add(count);
    }

    pause(vente.base.string());

     pause("setp-5");


    prix.deinitRecord(&vente);

    pause("setp-6 deinit");

    dcml.deinitDcml();

    pause("stop");
    count = dcml.init(5,0);
    count.setDcml("1");
    pause(count.string());




    const e1 = dcml.Expr{ .Val = 100 };
    try dcml.show(&e1, &stdout);
    try stdout.print(" = {d}\n", .{dcml.eval(&e1)});

    const e2 = dcml.Expr{ .Div = .{ .left = &dcml.Expr{ .Val = 10 }, .right = &dcml.Expr{ .Val = 2 } } };
    try dcml.show(&e2, &stdout);
    try stdout.print(" = {d}\n", .{dcml.eval(&e2)});



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
    try dcml.show(&e3, &stdout);
    try stdout.print(" = {d}\n", .{dcml.eval(&e3)});


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

    try dcml.show(&e4, &stdout);
    try stdout.print(" = {d}\n", .{dcml.eval(&e4)});



    const e5 = dcml.Expr{ .Div = .{ .left = &dcml.Expr{ .Val = 100 }, .right = &dcml.Expr{ .Val = 0 } } };
    try dcml.show(&e5, &stdout);
    try stdout.print(" = {d}\n", .{dcml.eval(&e5)});


    var t1 = dcml.init(5,1); t1.set(11.2);
    var t2 = dcml.init(5,0); t2.set(4);

    const e6 = dcml.Expr{
        .Mul = .{
            .left = &dcml.Expr{ .Val = t1.val },
            .right = &dcml.Expr{ .Val = t2.val },
        },
    };
    try dcml.show(&e6, &stdout);
    try stdout.print(" = {d}\n", .{dcml.eval(&e6)});




}

fn pause(text : [] const u8) void {
    std.debug.print("{s}\n",.{text});
   	var buf : [3]u8  =	[_]u8{0} ** 3;
	_= stdin.readUntilDelimiterOrEof(buf[0..], '\n') catch unreachable;

}
