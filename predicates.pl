
team(konyaspor, konya).
team(basaksehir, istanbul).
team(galatasaray, istanbul).
team(bursaspor, bursa).
team(karabukspor, karabuk).
team(trabzonspor, trabzon).
team(besiktas, istanbul).
team(fenerbahce, istanbul).
team(antepspor, antep).
team(antalyaspor, antalya).
team(ankaragucu, ankara).
team(genclerbirligi, ankara).
team(rizespor, rize).
team(goztepe, izmir).

match(1, galatasaray, 1, konyaspor, 6).
match(1, antalyaspor, 1, basaksehir, 1).
match(1, fenerbahce, 4, besiktas, 2).
match(1, genclerbirligi, 0, ankaragucu, 2).
match(1, antepspor, 1, karabukspor, 2).
match(1, trabzonspor, 2, bursaspor, 1).
match(1, rizespor, 2, goztepe, 1).

match(2, bursaspor, 2, rizespor, 2).
match(2, konyaspor, 4, antalyaspor, 0).
match(2, basaksehir, 2, fenerbahce, 3).
match(2, besiktas, 1, genclerbirligi, 1).
match(2, ankaragucu, 3, antepspor, 0).
match(2, karabukspor, 2, trabzonspor, 0).
match(2, galatasaray, 2, goztepe, 1).

match(3, trabzonspor, 3, goztepe, 1).
match(3, bursaspor, 2, konyaspor, 1).
match(3, antalyaspor, 1, antepspor, 0).
match(3, fenerbahce, 4, karabukspor, 0).
match(3, genclerbirligi, 1, galatasaray, 2).
match(3, ankaragucu, 1, basaksehir, 2).
match(3, rizespor, 2, besiktas, 1).

match(4, basaksehir, 1, trabzonspor, 0).
match(4, besiktas, 2, bursaspor, 2).
match(4, konyaspor, 0, genclerbirligi, 5).
match(4, antepspor, 4, fenerbahce, 0).
match(4, karabukspor, 4, antalyaspor, 2).
match(4, galatasaray, 0, rizespor, 1).
match(4, goztepe, 2, ankaragucu, 1).

match(5, antalyaspor, 4, bursaspor, 1).
match(5, genclerbirligi, 3, antepspor, 1).
match(5, karabukspor, 0, galatasaray, 0).
match(5, besiktas, 0, ankaragucu, 0).
match(5, basaksehir, 3, rizespor, 1).
match(5, fenerbahce, 2, trabzonspor, 0).
match(5, goztepe, 2, konyaspor, 1).



match(6, trabzonspor, 1, antepspor, 0).
match(6, antalyaspor, 0, bursaspor, 2).
match(6, genclerbirligi, 1, basaksehir, 0).
match(6, galatasaray, 2, besiktas, 0).
match(6, ankaragucu, 1, karabukspor, 2).
match(6, konyaspor, 2, fenerbahce, 0).



/** allTeams(L,N) is the predicate in which L is the list that contains all teams in random order and N is the number of elements 
in this list L. To find all the teams, findall(Object, Goal,List) predicate is used. That is a built in predicate of Prolog. To 
find N, the built-in predicate of Prolog lenght(List, Length) is used. And to list all permutations of the resulting list from findall 
predicate, permutation predicate is used.*/
allTeams(L,N) :- findall(X,team(X,_),Teamlist), permutation(L,Teamlist),length(Teamlist,N).

/* winMatch implies that in the match between teams Y and T, T won the match on week 
* W. */
winMatch(T,Y,W) :- match(W, T, W1,Y,W2), W1>W2.
winMatch(T,Y,W) :- match(W, Y, W1, T,W2), W1<W2.

/*If the given week is a number less than 1 in wins predicate, it halts because week can not be less than one. Other 
*parameters of wins predicate is _(anonymous variable) because they don't affect the result when W is wrong number.*/
wins(_,W,_,_) :- W<1 , break. 

/*In wins predicate if the team is on week, then there is only the matches played in first week. This condition is also the ending step
*of recursion.  */ 
wins(Team,1,List,Number) :- findall(Y, winMatch(Team,Y,1), List) , length(List, Number).

/*In this predicate of wins, week is more than 1, meaning there is at least one previous week to calculate. So wins predicate
*of previous week is called in recursive fashion then resulting list is appended with the current weeks list. */ 
wins(T,W,L,N) :- W>1 , findall(Y, winMatch(T,Y,W), List1) , W1 is W-1, wins(T,W1, List2, _) , append(List1, List2, L), length(L,N).  

/* lossMatch implies that in the match between teams Y and T, T lost the match on week 
* W. */
lossMatch(T,Y,W) :- match(W, T, L1,Y,L2), L1<L2.
lossMatch(T,Y,W) :- match(W, Y, L1, T,L2), L1>L2.

/*If the given week is a number less than 1 in losses predicate, it halts because week can not be less than one. Other 
*parameters of lossed predicate is _(anonymous variable) because they don't affect the result when W is wrong number.*/
losses(_,W,_,_) :- W<1 , break. 

/*In losses predicate if the team is on week, then there is only the matches played in first week. This condition is also the ending step
*of recursion.  */ 
losses(Team,1,List,Number) :- findall(Y, lossMatch(Team,Y,1), List) , length(List, Number).

/*In this predicate of losses, week is more than 1, meaning there is at least one previous week to calculate. So losses predicate
*of previous week is called in recursive fashion then resulting list is appended with the current weeks list. */ 
losses(T,W,L,N) :- W>1 , findall(Y, lossMatch(T,Y,W), List1) , W1 is W-1, losses(T,W1, List2, _) , append(List1, List2, L), length(L,N).  

/** drawMatch implies that in the match between teams Y and T, their scores were the same on week 
* W.*/
drawMatch(T,Y,W) :- match(W, T, D1,Y,D2), D1=D2.
drawMatch(T,Y,W) :- match(W, Y, D1, T,D2),D1=D2.

/*If the given week is a number less than 1 in draws predicate, it halts because week can not be less than one. Other 
*parameters of draws predicate is _(anonymous variable) because they don't affect the result when W is wrong number.*/
draws(_,W,_,_) :- W<1 , break. 

/*In draws predicate if the team is on week, then there is only the matches played in first week. This condition is also the ending step
*of recursion.  */ 
draws(Team,1,List,Number) :- findall(Y, drawMatch(Team,Y,1), List) , length(List, Number).

/*In this predicate of draws, week is more than 1, meaning there is at least one previous week to calculate. So draws predicate
*of previous week is called in recursive fashion then resulting list is appended with the current weeks list. */ 
draws(T,W,L,N) :- W>1 , findall(Y, drawMatch(T,Y,W), List1) , W1 is W-1, draws(T,W1, List2, _) , append(List1, List2, L), length(L,N).

/*If the given week is less than 1, that means error so the predicate is stopped.*/
scored(_,W,_) :- W<1 ,break.

/*If the given week is first week, then this implies that the scored goal number on this week is the S we are looking for. S is the total number of scored goals in matches in home and in guest team. To sum those the built-in function sum_list is used. This is also the end of recursion. */
scored(T,W,S) :- W=1 , findall(X, match(W,T,X,_,_), HomeScore), findall(Y,match(W,_,_,T,Y),GuestScore), append(HomeScore, GuestScore, Score), sum_list(Score, S).

/*If the given week is more than one, that means there is at least one previous week to calculate. So in this predicate at first the current week's scored goal number is calculated like in the previous scored predicate and this Score is added to the previous weeks score.*/
scored(T,W,S) :- W>1, findall(X, match(W,T,X,_,_), HomeScore), findall(Y,match(W,_,_,T,Y),GuestScore), append(HomeScore, GuestScore, CurrentScore),sum_list(CurrentScore, Score), W1 is W-1, scored(T,W1, PrevScore), S is Score+PrevScore .

/*Like in the previous predicates when W is less than one predicate terminates.*/
conceded(_,W,_) :- W<1, break.

/*If the given week is first week, then this implies that the conceded goal number on this week is the C we are looking for. C is the total number of conceded goals in matches in home and in guest team. To sum those the built-in function sum_list is used. This is also the end of recursion. */
conceded(T,W,C) :- W=1 , findall(X, match(W,T,_,_,X), HomeConceded), findall(Y,match(W,_,Y,T,_),GuestConceded), append(HomeConceded, GuestConceded, Conceded), sum_list(Conceded, C).

/*If the given week is more than one, that means there is at least one previous week to calculate. So in this predicate at first the current week's conceded goal number is calculated like in the previous conceded predicate and this Conceded is added to the previous week's conceded.*/
conceded(T,W,C) :- W>1, findall(X, match(W,T,_,_,X), HomeConceded), findall(Y,match(W,_,Y,T,_),GuestConceded), append(HomeConceded, GuestConceded, CurrentConceded),sum_list(CurrentConceded, Conceded), W1 is W-1, conceded(T,W1, PrevConceded), C is Conceded+PrevConceded .

/*Week can not be less than one.*/
average(_,W,_) :- W<1, break.

/*S is the scored goal number by team T up to week W and C is the conceded goal number up to week W. A is S-C.*/
average(T,W,A) :- scored(T,W,S) , conceded(T,W,C), A is S-C.

/*Below predicates are the classical insertion sort algorithm that sorts a list of teams according to their averages on given week W in an descending order.*/
insert_sort(List,Sorted,W):-i_sort(List,[],Sorted,W).
i_sort([],Acc,Acc,_).
i_sort([H|T],Acc,Sorted,W):-insert(H,Acc,NAcc,W),i_sort(T,NAcc,Sorted,W). 
insert(X,[Y|T],[Y|NT],W):- average(X,W,AvX),average(Y,W,AvY),AvX<AvY,insert(X,T,NT,W).
insert(X,[Y|T],[X,Y|T],W):- average(X,W,AvX),average(Y,W,AvY), AvX>AvY.
insert(X,[Y|T],[Y|NT],W):- average(X,W,AvX),average(Y,W,AvY),AvX=AvY,insert(X,T,NT,W).
insert(X,[Y|T],[X,Y|T],W):- average(X,W,AvX),average(Y,W,AvY), AvX=AvY.
insert(X,[],[X],_).

/*W must be larger or equal to one in order predicate because week con not be less than one. In this predicate Teams list is allTeams
then L is the sorted version of Teams list.*/
order(L,W) :- W>=1, allTeams(Teams,_) , insert_sort(Teams, L, W).

/*T1,T2 and T3 in topThree predicate are the first three elements of the list L in order(L,W) predicate. */
topThree([T1,T2, T3],W) :- order(L,W), L=[T1,T2,T3|_].


