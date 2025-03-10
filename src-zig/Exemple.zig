const std = @import("std");

const dcml = @import("decimal").DCMLFX;


const stdout = std.io.getStdOut().writer();
const stdin = std.io.getStdIn().reader();

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
stdout.writeAll("\x1b[2J") catch {};
stdout.writeAll("\x1b[3J") catch {};
stdout.print("\x1b[{d};{d}H", .{ 1, 1 }) catch {};
var work :dcml = dcml.init(15,15);


var article  = prix.init ();
// Nom de l'article
article.name = "vis acier";

stdout.print("name.{s}\n",.{article.name}) catch {};

// poids de la matière tonne
article.poids.set(3.00) ;
stdout.print("poids.{s}.T\n",.{article.poids.string()}) catch {};



// prix de la tonne 450 €
article.prixBase.set(450.00) ;
stdout.print("prixBase.{s}€ par tonne \n",.{article.prixBase.string()}) catch {};



// remise %
article.refund.set(2.00) ;
stdout.print("refund.{s}% remise\n",.{article.refund.string()}) catch {};



// prix d'achat
article.prixAchat.multTo(article.poids,article.prixBase) ;
_=work.percent(article.prixAchat, article.refund);
article.prixAchat.add(work);
stdout.print("prixAchat.{s}€ avec remise\n",.{article.prixAchat.string()}) catch {};



// prix au Gramme
work.set(1000000);
_=article.prixGramme.divTo(article.prixAchat,work) ;
stdout.print("prixGramme.{s}€\n",.{article.prixGramme.string()}) catch {};



// poids d'une vis
article.poidsUnite.set(4.5) ;
stdout.print("poidsUnite.{s} poids d'une vis\n",.{article.poidsUnite.string()}) catch {};



// increase %
article.increase.set(0.05) ;
stdout.print("increase.{s}% perte fabrication\n",.{article.increase.string()}) catch {};



// poids fabricationi d'une vis
_=work.percent(article.poidsUnite, article.increase) ;
article.poidsFab.addTo(article.poidsUnite, work);
stdout.print("poidsFab.{s}gr d'une vis\n",.{article.poidsFab.string()}) catch {};



// calcul nombre article
work.set(1000000);
work.mult(article.poids);// convert. en gramme
_=article.nbrArticle.divTo(work,article.poidsFab);
stdout.print("nbrArticle.{s}\n",.{article.nbrArticle.string()}) catch {};



// prix de fabrication d'une vis
article.prixFab.multTo(article.prixGramme,article.poidsFab);
stdout.print("prixFab.{s}€ d'un article\n",.{article.prixFab.string()}) catch {};


// mont de fabrication 
article.montFab.multTo(article.prixFab,article.nbrArticle);
stdout.print("montFab.{s}€ total d'article\n",.{article.montFab.string()}) catch {};



// prix de vente
article.prixVente.set(61.51); //cts soit 615,1€ les dix acier pour béton
stdout.print("prixVente.{s}€ l'article\n",.{article.prixVente.string()}) catch {};

// mont de vente
article.montVente.multTo(article.prixVente,article.nbrArticle);
stdout.print("montVente.{s}€\n",.{article.montVente.string()}) catch {};

// mont de salairs integration participation
work.set(20.0);
_=article.salairs.percent(article.montVente,work);
stdout.print("salairs.{s}\n",.{article.salairs.string()}) catch {};

// mont de impots TAX
work.set(25.0);
_=article.impots.percent(article.montVente,work);
stdout.print("impots.{s}€\n",.{article.impots.string()}) catch {};


// mont de charge maintenance investissementi epargne
work.set(10.0);
_=article.maintenance.percent(article.montVente,work);
stdout.print("maintenance.{s}€\n",.{article.maintenance.string()}) catch {};


stdout.print("prixAchat.{s}€ matière première\n",.{article.prixAchat.string()}) catch {};

// benefice

work.subTo(article.montVente, article.impots);
work.subTo(work, article.salairs);
article.benefice.subTo(work,article.maintenance);
article.benefice.sub(article.prixAchat);
// attention aux arrondis
article.benefice.round();
stdout.print("benefice.{s}\n",.{article.benefice.string()}) catch {};


// autre mode de calcul avec une evaluation d'expression
stdout.print("\n test eval-expression  result:f128 \n",.{}) catch {};
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


    try dcml.show(&E_benefice, &stdout);
    try stdout.print(" = {d}\n", .{dcml.eval(&E_benefice)});

    article.benefice.set(dcml.eval(&E_benefice));
    article.benefice.round();
    stdout.print("benefice.{s}\n",.{article.benefice.string()}) catch {};

    
prix.deinitRecord(&article);

pause("deinitDcml()");
dcml.deinitDcml();

pause("fin");
}
fn pause(text : [] const u8) void {
    std.debug.print("{s}\n",.{text});
    var buf : [3]u8  = [_]u8{0} ** 3;
	_= stdin.readUntilDelimiterOrEof(buf[0..], '\n') catch unreachable;

}


