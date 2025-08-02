const std = @import("std");

const dcml = @import("decimal").DCMLFX;


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

//=================================

pub const prix = struct {
  name       : []const u8   , // Nom de l'article
  poids      : dcml , // tonnes ex 1.5 tonnes
  prixBase   : dcml , // montant achat de la tonne
  prixGramme : dcml , // montant achat du gramme
  refund     : dcml , // % refund
  prixAchat  : dcml , // montant achat
  poidsUnite : dcml , // montant achat
  increase   : dcml , // increase usinage spécifique 
  prixFab    : dcml , // prix fabrication brut + 40% gestion salaire investissement ....
  impots     : dcml , // fiscalité impot 25%
  salairs    : dcml , // salaire 20%
  maintenance: dcml , // investissement maintenance  10%
  poidsFab   : dcml , // poids d'un article à la fabrication gramme
  nbrArticle : dcml , // nombre d'artcile fab maxi.
  prixVente  : dcml , // prix de vente unitaire de base
  montFab    : dcml , // montant de la fabrication
  montVente  : dcml , // profit sur un article
  benefice   : dcml , // benefice par tonne

  // defined structure and set "0"
    pub fn init() prix {
        return prix {
            .name = "",
            .poids      = dcml.init(3,1),
            .prixBase   = dcml.init(8,2),
            .prixGramme = dcml.init(5,6),
            .refund     = dcml.init(3,2),
            .prixAchat  = dcml.init(8,2),
            .poidsUnite = dcml.init(5,2),
            .increase   = dcml.init(3,2), 
            .prixFab    = dcml.init(4,6),
            .impots     = dcml.init(13,2),
            .salairs    = dcml.init(8,2),
            .maintenance= dcml.init(8,2),
            .poidsFab   = dcml.init(5,2),
            .nbrArticle = dcml.init(15,0),
            .prixVente  = dcml.init(4,2),
            .montFab    = dcml.init(4,2),
            .montVente  = dcml.init(8,2),
            .benefice   = dcml.init(18,2),
        };
    }

    pub fn deinitRecord( r :*prix) void {
        r.name =undefined;
        dcml.deinit(&r.poids); 
        dcml.deinit(&r.prixBase);
        dcml.deinit(&r.prixGramme);
        dcml.deinit(&r.refund);
        dcml.deinit(&r.prixAchat);
        dcml.deinit(&r.poidsUnite); 
        dcml.deinit(&r.increase);
        dcml.deinit(&r.prixFab);
        dcml.deinit(&r.impots);
        dcml.deinit(&r.salairs);
        dcml.deinit(&r.maintenance);
        dcml.deinit(&r.nbrArticle);
        dcml.deinit(&r.prixVente);
        dcml.deinit(&r.montFab);
        dcml.deinit(&r.montVente);
        dcml.deinit(&r.benefice);
    }

};





pub fn main() !void {
    WriteAll("\x1b[2J");
    WriteAll("\x1b[3J");
    Print("\x1b[{d};{d}H", .{ 1, 1 });

    
var work :dcml = dcml.init(15,15);


var article  = prix.init ();
// Nom de l'article
article.name = "vis acier";

Print("name.{s}\n",.{article.name});

// poids de la matière tonne
article.poids.set(3.00) ;
Print("poids.{s}.T\n",.{article.poids.string()});



// prix de la tonne 450 €
article.prixBase.set(450.00) ;
Print("prixBase.{s}€ par tonne \n",.{article.prixBase.string()});



// remise %
article.refund.set(2.00) ;
Print("refund.{s}% remise\n",.{article.refund.string()});



// prix d'achat
article.prixAchat.multTo(article.poids,article.prixBase) ;
_=work.percent(article.prixAchat, article.refund);
article.prixAchat.add(work);
Print("prixAchat.{s}€ avec remise\n",.{article.prixAchat.string()});



// prix au Gramme
work.set(1000000);
_=article.prixGramme.divTo(article.prixAchat,work) ;
Print("prixGramme.{s}€\n",.{article.prixGramme.string()});



// poids d'une vis
article.poidsUnite.set(4.5) ;
Print("poidsUnite.{s} poids d'une vis\n",.{article.poidsUnite.string()});



// increase %
article.increase.set(0.05) ;
Print("increase.{s}% perte fabrication\n",.{article.increase.string()});



// poids fabricationi d'une vis
_=work.percent(article.poidsUnite, article.increase) ;
article.poidsFab.addTo(article.poidsUnite, work);
Print("poidsFab.{s}gr d'une vis\n",.{article.poidsFab.string()});



// calcul nombre article
work.set(1000000);
work.mult(article.poids);// convert. en gramme
_=article.nbrArticle.divTo(work,article.poidsFab);
Print("nbrArticle.{s}\n",.{article.nbrArticle.string()});



// prix de fabrication d'une vis
article.prixFab.multTo(article.prixGramme,article.poidsFab);
Print("prixFab.{s}€ d'un article\n",.{article.prixFab.string()});


// mont de fabrication 
article.montFab.multTo(article.prixFab,article.nbrArticle);
Print("montFab.{s}€ total d'article\n",.{article.montFab.string()});



// prix de vente
article.prixVente.set(61.51); //cts soit 615,1€ les dix acier pour béton
Print("prixVente.{s}€ l'article\n",.{article.prixVente.string()});

// mont de vente
article.montVente.multTo(article.prixVente,article.nbrArticle);
Print("montVente.{s}€\n",.{article.montVente.string()});

// mont de salairs integration participation
work.set(20.0);
_=article.salairs.percent(article.montVente,work);
Print("salairs.{s}\n",.{article.salairs.string()});

// mont de impots TAX
work.set(25.0);
_=article.impots.percent(article.montVente,work);
Print("impots.{s}€\n",.{article.impots.string()});


// mont de charge maintenance investissementi epargne
work.set(10.0);
_=article.maintenance.percent(article.montVente,work);
Print("maintenance.{s}€\n",.{article.maintenance.string()});


Print("prixAchat.{s}€ matière première\n",.{article.prixAchat.string()});

// benefice

work.subTo(article.montVente, article.impots);
work.subTo(work, article.salairs);
article.benefice.subTo(work,article.maintenance);
article.benefice.sub(article.prixAchat);
// attention aux arrondis
article.benefice.round();
Print("benefice.{s}\n",.{article.benefice.string()});


// autre mode de calcul avec une evaluation d'expression
Print("\n test eval-expression  result:f128 \n",.{});
const E_benefice = dcml.Expr{
        .Sub = .{
            .left = &dcml.Expr{
                .Sub = .{
                    .left = &dcml.Expr{ .Val = article.montVente.val },
                    .right = &dcml.Expr{ .Val = article.prixAchat.val },
                },
            },
            .right = &dcml.Expr{
                .Add = .{
                    .left = &dcml.Expr{ .Val = article.maintenance.val },
                    .right = &dcml.Expr{
                        .Add =.{
                            .left = &dcml.Expr{ .Val = article.salairs.val },
                            .right = &dcml.Expr{ .Val = article.impots.val },
                        },
                    },
                },
            },
        },    
    };


    try dcml.show(&E_benefice);
    Print(" = {d}\n", .{dcml.eval(&E_benefice)});

    article.benefice.set(dcml.eval(&E_benefice));
    article.benefice.round();
    Print("benefice.{s}\n",.{article.benefice.string()});

    
prix.deinitRecord(&article);

Pause("deinitDcml()");
dcml.deinitDcml();

Pause("fin");
}


