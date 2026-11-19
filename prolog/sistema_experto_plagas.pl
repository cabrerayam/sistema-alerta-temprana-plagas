% =====================================================================
% Sistema experto: riesgo de chicharrita del maiz (Dalbulus maidis)
% Trabajo Practico Integrador - Inteligencia Artificial - UP
% Usa las mismas reglas que el notebook (seccion 3).
%
% Uso:   swipl sistema_experto_plagas.pl
%        ?- riesgo(dia_2024_03_15, R).
%        ?- recomendacion(dia_2024_03_15, A).
%        ?- informe(dia_2024_07_10).
% =====================================================================

% --- HECHOS: clima de cada dia (datos reales de NASA POWER, Pergamino) ---
% clima(Dia, TempMax, TempMin, Humedad, Lluvia7Dias, InviernoPrevioBenigno).
clima(dia_2024_03_15, 28.3, 20.0, 90.1, 132.4, si).   % caso de riesgo alto
clima(dia_2024_03_05, 25.9, 11.6, 61.4,  24.4, si).   % caso de riesgo medio
clima(dia_2024_10_20, 32.6, 15.2, 61.5,  17.2, no).   % invierno 2024 con heladas
clima(dia_2024_07_10,  9.5, -2.9, 66.4,   0.0, no).   % pleno invierno

% --- REGLAS: factores favorables a la plaga ---
factor(Dia, temperatura) :-
    clima(Dia, TMax, TMin, _, _, _),
    TMax >= 26, TMax =< 32, TMin >= 5.
factor(Dia, humedad) :-
    clima(Dia, _, _, H, _, _), H >= 65.
factor(Dia, lluvia) :-
    clima(Dia, _, _, _, L, _), L >= 10.
factor(Dia, invierno_benigno) :-
    clima(Dia, _, _, _, _, si).

% Cantidad de factores que se cumplen
cantidad_factores(Dia, N) :-
    findall(F, factor(Dia, F), Lista),
    length(Lista, N).

% --- REGLAS DE PRODUCCION: nivel de riesgo ---
riesgo(Dia, alto)  :- cantidad_factores(Dia, N), N >= 3.
riesgo(Dia, medio) :- cantidad_factores(Dia, N), N =:= 2.
riesgo(Dia, bajo)  :- cantidad_factores(Dia, N), N =< 1.

% --- REGLAS DE RECOMENDACION ---
recomendacion(Dia, control_preventivo_y_monitoreo_semanal) :- riesgo(Dia, alto).
recomendacion(Dia, monitoreo_quincenal_con_trampas)        :- riesgo(Dia, medio).
recomendacion(Dia, monitoreo_rutinario)                    :- riesgo(Dia, bajo).

% --- Informe legible (explica por que se llega a la conclusion) ---
informe(Dia) :-
    findall(F, factor(Dia, F), Factores),
    riesgo(Dia, R),
    recomendacion(Dia, A),
    format("Dia: ~w~nFactores favorables: ~w~nRiesgo: ~w~nRecomendacion: ~w~n",
           [Dia, Factores, R, A]).
