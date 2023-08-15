%Base de conocimiento
animal(ginger, gallina(10, 5)).
animal(babs, gallina(15, 2)).
animal(bunty, gallina(23, 6)).
animal(mac, gallina(8, 7)).
animal(turuleca, gallina(15, 1)).
animal(rocky, gallo(animalDeCirco)).
animal(fowler, gallo(piloto)).
animal(oro, gallo(arrocero)).
animal(nick, rata).
animal(fetcher, rata).

granja(tweedys, [ginger, babs, bunty, mac, fowler]).
granja(delSol, [turuleca, oro, nick, fetcher]).

%Punto 1:
puedeCederle(UnaGallina, OtraGallina):-
    esTrabajadora(UnaGallina),
    esHaragana(OtraGallina).

esTrabajadora(Gallina):-
    huevosQueProduce(Gallina, 7).
esHaragana(Gallina):-
    huevosQueProduce(Gallina, Huevos),
    Huevos < 3.

huevosQueProduce(Gallina, Huevos):-
    animal(Gallina, gallina(_,Huevos)).

%Punto 2:
animalLibre(Animal):-
    animal(Animal,_),
    not(viveEn(Animal,_)).

viveEn(Animal,Lugar):-
    granja(Lugar, Animales),
    member(Animal, Animales).

%Punto 3:
valoracionGranja(Granja,Valoracion):-
    granja(Granja,_),
    findall(ValoracionAnimal, valoracionPorAnimal(Granja, ValoracionAnimal), Valoraciones),
    sum_list(Valoraciones, Valoracion).

valoracionPorAnimal(Granja, ValoracionAnimal):-
    tipoDeAnimalQueViveEn(_,Tipo,Granja),
    valoracionTipoDeAnimal(Tipo, ValoracionAnimal).

tipoAnimal(Animal,Tipo):-
    animal(Animal,Tipo).

valoracionTipoDeAnimal(gallina(Peso, Huevos), Valor):-
    Valor is Peso * Huevos.
valoracionTipoDeAnimal(gallo(Profesion), 50):-
    sabeVolar(Profesion).
valoracionTipoDeAnimal(gallo(Profesion), 25):-
    not(sabeVolar(Profesion)).


sabeVolar(Profesion):-
    member(Profesion,[piloto, animalDeCirco]).

%Punto 4:
granjaDeluxe(Granja):-
    tieneMasDe50AnimalOValoracion1000(Granja),
    not(tieneAlgunaRata(Granja)).

tieneAlgunaRata(Granja):-
    tipoDeAnimalQueViveEn(_,rata,Granja).

tieneMasDe50AnimalOValoracion1000(Granja):-
    cantidadAnimales(Granja,Cantidad),
    Cantidad > 50.
tieneMasDe50AnimalOValoracion1000(Granja):-
    valoracionGranja(Granja, 1000).

cantidadAnimales(Granja, Cantidad):-
    granja(Granja,Animales),
    length(Animales,Cantidad).

%Punto 5:
buenaPareja(Animal, OtroAnimal):-
    tipoDeAnimalQueViveEn(Animal,Tipo,Granja),
    tipoDeAnimalQueViveEn(OtroAnimal,OtroTipo,Granja),
    sonCompatibles(animal(Animal,Tipo),animal(OtroAnimal, OtroTipo)).

tipoDeAnimalQueViveEn(Animal, Tipo, Granja):-
    tipoAnimal(Animal, Tipo),
    viveEn(Animal, Granja).

sonCompatibles(animal(Nombre,_), animal(OtroNombre,_)):-
    algunaPuedeCederle(Nombre,OtroNombre).
sonCompatibles(animal(Nombre,rata), animal(OtroNombre,rata)):-
    Nombre \= OtroNombre.
sonCompatibles(animal(_,gallo(Profesion)), animal(_,gallo(OtraProfesion))):-
    profesionesCompatibles(Profesion,OtraProfesion).

algunaPuedeCederle(Gallina, OtraGall):-
    puedeCederle(Gallina, OtraGall).
algunaPuedeCederle(Gallina, OtraGall):-
    puedeCederle(OtraGall, Gallina).

profesionesCompatibles(Profesion, OtraProfesion):-
    unoPuedeVolarYElOtroNo(Profesion,OtraProfesion).
profesionesCompatibles(Profesion, OtraProfesion):-
    unoPuedeVolarYElOtroNo(OtraProfesion, Profesion).

unoPuedeVolarYElOtroNo(Profesion, OtraProfesion):-
    sabeVolar(Profesion),
    not(sabeVolar(OtraProfesion)).

%Punto 6:
escapePerfecto(Granja):-
    granja(Granja,_),
    forall(tipoDeAnimalQueViveEn(Animal,_,Granja), buenaPareja(Animal, _)),
    forall(tipoDeAnimalQueViveEn(OtroAnimal,gallina(_,_), Granja), poneMasDeNHuevos(5,OtroAnimal)).

poneMasDeNHuevos(Cantidad, Animal):-
    huevosQueProduce(Animal, Huevos),
    Huevos > Cantidad.
