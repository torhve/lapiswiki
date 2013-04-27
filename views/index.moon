import Widget from require "lapis.html"
class Index extends Widget
    content: =>
        div class: "body", ->
            h1 contenteditable:"true", @page_title
            p contenteditable:"true", raw [[
                Lapis Wiki is a very simple demo application built using <a href="http://leafo.net/lapis/">Lapis</a> and <a href="http://ckeditor.com/">CKEditor</a>. Primary motivation for building was playing with the Lapis framework, and also making a proof of fconcept of a Wiki that can accept pasted images. Hello, it's 2013, browsers have capabilities yet wikis do not.
]]
        p contenteditable:"true", [[

            Try editing some of this content to see CKEditor in action. Det er et velkjent faktum at lesere distraheres av lesbart innhold på en side når man ser på dens layout. Poenget med å bruke Lorem Ipsum er at det har en mer eller mindre normal fordeling av bokstaver i ord, i motsetning til 'Innhold her, innhold her', og gir inntrykk av å være lesbar tekst. Mange webside- og sideombrekkingsprogrammer bruker nå Lorem Ipsum som sin standard for provisorisk tekst, og et søk etter 'Lorem Ipsum' vil avdekke mang en uferdig webside. Ulike versjoner har sprunget frem i senere år, noen ved rene uhell og andre mer planlagte (med humor o.l.).
]]
        pre contenteditable:"true", [[
 
I motsetning til hva mange tror, er ikke Lorem Ipsum bare tilfeldig tekst. Dets røtter springer helt tilbake til et stykke klassisk latinsk litteratur fra 45 år f.kr., hvilket gjør det over 2000 år gammelt. Richard McClintock - professor i latin ved Hampden-Sydney College i Virginia, USA - slo opp flere av de mer obskure latinske ordene, consectetur, fra en del av Lorem Ipsum, og fant dets utvilsomme opprinnelse gjennom å studere bruken av disse ordene i klassisk litteratur. Lorem Ipsum kommer fra seksjon 1.10.32 og 1.10.33 i "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) av Cicero, skrevet i år 45 f.kr. Boken er en avhandling om teorier rundt etikk, og var veldig populær under renessansen. Den første linjen av Lorem Ipsum, "Lorem Ipsum dolor sit amet...", er hentet fra en linje i seksjon 1.10.32.
]]
        p contenteditable:"true", [[

Standardbiten av Lorem Ipsum brukt siden 1500-tallet er gjengitt nedenfor for spesielt interesserte. Seksjon 1.10.32 og 1.10.33 fra "de Finibus Bonorum et Malorum" av Cicero er også eksakt gjengitt, akkompagnert av engelske versjoner fra 1914-oversettelsen av H. Rackham.

Det finnes mange ulike varianter av Lorem Ipsum, men majoriteten av disse har blitt tuklet med på et eller annet vis. Det være seg innlagt humor eller tilfeldig genererte ord som ser langt fra troverdige ut. Skal man bruke avsnitt av Lorem Ipsum må man være sikker på at det ikke skjuler seg noe pinlig midt i teksten. Lorem Ipsum-generatorer på internett har en tendens til å repetere forhåndsdefinerte biter av tekst, noe som gjør dette til den første rettmessige generatoren på nett. Den bruker en samling av over 200 latinske ord, kombinert med en håndfull av setningsstrukturer, som sammen genererer Lorem Ipsum som ser fornuftig ut. Ferdiggenerert Lorem Ipsum er derfor alltid fri for repetisjon, innlagt humor, ugjenkjennlige ordformer osv.

]]
        p contenteditable:"true", [[
    
    paragrafer
    ord
    bytes
    lister
Begynn med 'Lorem ipsum dolor sit amet...'
]] 
