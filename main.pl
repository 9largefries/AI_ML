main :-
write('Wellcome to our expert system'), nl,
write('"OMERZITELNAIY 4ETVERKA PLUS KATE"'), nl,
write('Maria Somova, Igor Kornev, Dmitriy Gonchar, Dmitriy Krivenko, Katerina Tektonidi'), nl,
write('To answer, input the number shown next to each answer, followed by a dot (.)'), nl, nl,
reset_answers,
find_notebook(Notebook),nl.
find_notebook(Notebook) :-
notebook(Notebook), write(Notebook), !.

reset_answers :-
retract(choose(_, _)),
fail.
reset_answers.

%Ответы к brag_question
answer(apple) :-
write('Apple').

answer(asus) :-
write('Asus').

answer(acer) :-
write('Acer').

answer(lenovo) :-
write('Lenovo').

answer(dell) :-
write('Dell').

answer(msi) :-
write('MSI').

%Ответы к game_matrix
answer(fast_matrix) :-
write('Fast matrix').

answer(high_quality_matrix) :-
write('High-quality matrix').

%Ответы к battery
answer(no_less_than_7_hours) :-
write('No less than 7 hours').

answer(movies_or_play_arcades) :-
write('I can watch 1-2 movies or a long time to play arcades').

answer(mail_news_social_network) :-
write('Check mail, watch news, look at social network').

%Ответы к other_things
answer(premium) :-
write('I want all premium options!').

answer(backlit) :-
write('Just want a backlit keyboard').

answer(matrix) :-
write('The best quality of the matrix, the phenomenal color rendering and the resolution is not less than Full HD').

answer(body) :-
write('I want the body to be made of high-quality materials').

%Ответы для difficulty_tasks
answer(working_several_application) :-
write('At the same time working a lot of application').

answer(games_3D) :-
write('I will play 3D games of the latest generation').

answer(office_application_internet_movies) :-
write('Office applications, internet, movies').

% Ответы к mobility
answer(every_day) :-
write('I will carry it every day').

answer(sometimes) :-
write('I will carry it sometimes').

answer(never) :-
write('Instead of a desktop computer').

% Ответы к target
answer(for_work) :-
write('Only for work').

answer(professional) :-
write('3D-modelling, video production').

answer(games) :-
write('Only for games').

answer(work_games) :-
write('For work and games (universal)').

answer(internet_movies_education) :-
write('For internet surfing, watchin movies, education and social networks').

answer(dont_know) :-
write('I do not know').

answer(brag) :-
write('I want to brag to friends').

% Находит ответ из Choices
parse(0, [First|_], First).
parse(Index, [First|Rest], Response) :-
Index > 0,
NextIndex is Index - 1,
parse(NextIndex, Rest, Response).

% Вывод вопросов из Choices
answers([], _).
answers([First|Rest], Index) :-
write(Index), write(' '), answer(First), nl,
NextIndex is Index + 1,
answers(Rest, NextIndex).

% Задает и сохраняет вопрос
ask(Question, Answer, Choices) :-
question(Question),
answers(Choices, 0),
read(Index),
parse(Index, Choices, Response),
asserta(choose(Question, Response)),
Response = Answer.

brag_question(Answer) :-
choose(brag_question, Answer).
brag_question(Answer) :-
\+ choose(brag_question, _),
ask(brag_question, Answer, [apple, asus, acer, lenovo, dell, msi]).

battery(Answer) :-
choose(battery, Answer).
battery(Answer) :-
\+ choose(battery, _),
ask(battery, Answer, [mail_news_social_network, movies_or_play_arcades, no_less_than_7_hours]).  

other_things(Answer) :-
choose(other_things, Answer).
other_things(Answer) :-
\+ choose(other_things, _),
ask(other_things, Answer, [premium, backlit, matrix, body]).

difficulty_tasks(Answer) :-
choose(difficulty_tasks, Answer).
difficulty_tasks(Answer) :-
\+ choose(difficulty_tasks, _),
ask(difficulty_tasks, Answer, [working_several_application, games_3D, office_application_internet_movies]).

mobility(Answer) :-
choose(mobility, Answer).
mobility(Answer) :-
\+ choose(mobility, _),
ask(mobility, Answer, [every_day, sometimes, never]).

game_matrix(Answer) :-
choose(game_matrix, Answer).
game_matrix(Answer) :-
\+ choose(game_matrix, _),
ask(game_matrix, Answer, [fast_matrix, high_quality_matrix]).

target(Answer) :-
choose(target, Answer).
target(Answer) :-
\+ choose(target, _),
ask(target, Answer, [for_work, professional, games, work_games, internet_movies_education, dont_know, brag]).

%Правила для базы
notebook('MacBook Pro 17 TouchBar') :-
target(dont_know).

notebook('MacBook Pro 17 TouchBar') :-
target(brag),
brag_question(apple).

notebook('Asus ZenBook 3') :-
target(brag),
brag_question(asus).

notebook('MSI GE62VR') :-
target(brag),
brag_question(msi).

notebook('Lenovo IdeaPad') :-
target(brag),
brag_question(lenovo).

notebook('Acer Predator') :-
target(brag),
brag_question(acer).

notebook('Dell Inspiron') :-
target(brag),
brag_question(dell).

notebook('HP Steam X360') :-
target(internet_movies_education),
mobility(every_day),
battery(mail_news_social_network),
other_things(premium).

notebook('Lenovo IdeaPad 7205-13') :-
target(internet_movies_education),
mobility(every_day),
battery(mail_news_social_network),
other_things(backlit).

notebook('HP Envy 13') :-
target(internet_movies_education),
mobility(every_day),
battery(mail_news_social_network),
other_things(matrix).

notebook('Lenovo ThinkPad X270') :-
target(internet_movies_education),
mobility(every_day),
battery(mail_news_social_network),
other_things(body).

notebook('HP ProBook 430') :-
target(internet_movies_education),
mobility(every_day),
battery(movies_or_play_arcades),
other_things(premium).

notebook('Apple MacBook 12 2017') :-
target(internet_movies_education),
mobility(every_day),
battery(movies_or_play_arcades),
other_things(backlit).

notebook('Asus Transformer 3 T 805 CA') :-
target(internet_movies_education),
mobility(every_day),
battery(movies_or_play_arcades),
other_things(matrix).

notebook('HP EliteBook Folio') :-
target(internet_movies_education),
mobility(every_day),
battery(movies_or_play_arcades),
other_things(body).

notebook('Lenovo ThinkPad X270') :-
target(internet_movies_education),
mobility(every_day),
battery(no_less_than_7_hours),
other_things(premium).

notebook('Lenovo ThinkPad X270') :-
target(internet_movies_education),
mobility(every_day),
battery(no_less_than_7_hours),
other_things(backlit).

notebook('Lenovo ThinkPad X270') :-
target(internet_movies_education),
mobility(every_day),
battery(no_less_than_7_hours),
other_things(matrix).

notebook('Lenovo ThinkPad X270') :-
target(internet_movies_education),
mobility(every_day),
battery(no_less_than_7_hours),
other_things(body).

notebook('HP Pavilion 14') :-
target(internet_movies_education),
mobility(sometimes),
battery(mail_news_social_network),
other_things(premium).

notebook('Dell Inspiron 5378') :-
target(internet_movies_education),
mobility(sometimes),
battery(mail_news_social_network),
other_things(backlit).

notebook('Dell Vostro') :-
target(internet_movies_education),
mobility(sometimes),
battery(mail_news_social_network),
other_things(matrix).

notebook('Acer Swift') :-
target(internet_movies_education),
mobility(sometimes),
battery(mail_news_social_network),
other_things(body).

notebook('HP 15-bw 510 ur') :-
target(internet_movies_education),
mobility(sometimes),
battery(movies_or_play_arcades),
other_things(premium).

notebook('HP Pavilion 15') :-
target(internet_movies_education),
mobility(sometimes),
battery(movies_or_play_arcades),
other_things(backlit).

notebook('Lenovo IdeaPad 520s-14') :-
target(internet_movies_education),
mobility(sometimes),
battery(movies_or_play_arcades),
other_things(matrix).

notebook('Asus VivoBook Flip') :-
target(internet_movies_education),
mobility(sometimes),
battery(movies_or_play_arcades),
other_things(body).

notebook('HP-17 ak084ur') :-
target(internet_movies_education),
mobility(sometimes),
battery(no_less_than_7_hours),
other_things(premium).

notebook('HP-17 ak092ur') :-
target(internet_movies_education),
mobility(sometimes),
battery(no_less_than_7_hours),
other_things(backlit).

notebook('HP-17 ak092ur') :-
target(internet_movies_education),
mobility(sometimes),
battery(no_less_than_7_hours),
other_things(matrix).

notebook('HP Pavilion 15') :-
target(internet_movies_education),
mobility(sometimes),
battery(no_less_than_7_hours),
other_things(body).

notebook('Lenovo ThinkPad Edge') :-
target(internet_movies_education),
mobility(never),
battery(mail_news_social_network),
other_things(premium).

notebook('Dell Vostro') :-
target(internet_movies_education),
mobility(never),
battery(mail_news_social_network),
other_things(backlit).

notebook('Dell Latitude') :-
target(internet_movies_education),
mobility(never),
battery(mail_news_social_network),
other_things(matrix).

notebook('HP Envy') :-
target(internet_movies_education),
mobility(never),
battery(mail_news_social_network),
other_things(body).

notebook('Asus R06') :-
target(internet_movies_education),
mobility(never),
battery(movies_or_play_arcades),
other_things(premium).

notebook('HP Envy X360') :-
target(internet_movies_education),
mobility(never),
battery(movies_or_play_arcades),
other_things(backlit).

notebook('Asus VivoBook S15') :-
target(internet_movies_education),
mobility(never),
battery(movies_or_play_arcades),
other_things(matrix).

notebook('Asus VivoBook S15') :-
target(internet_movies_education),
mobility(never),
battery(movies_or_play_arcades),
other_things(body).

notebook('Lenovo IdeaPad 320-17') :-
target(internet_movies_education),
mobility(never),
battery(no_less_than_7_hours),
other_things(premium).

notebook('Lenovo IdeaPad 320-17') :-
target(internet_movies_education),
mobility(never),
battery(no_less_than_7_hours),
other_things(backlit).

notebook('Asus R06') :-
target(internet_movies_education),
mobility(never),
battery(no_less_than_7_hours),
other_things(matrix).

notebook('Asus R06') :-
target(internet_movies_education),
mobility(never),
battery(no_less_than_7_hours),
other_things(body).

notebook('Lenovo ThinkPad T480s') :-
target(for_work),
mobility(every_day),
difficulty_tasks(working_several_application).

notebook('Lenovo ThinkPad T480s') :-
target(for_work),
mobility(every_day),
difficulty_tasks(games_3D).

notebook('HP Envy 13') :-
target(for_work),
mobility(every_day),
difficulty_tasks(office_application_internet_movies).

notebook('ASUS Zenbook Flip') :-
target(for_work),
mobility(sometimes),
difficulty_tasks(working_several_application).

notebook('ASUS Zenbook Flip') :-
target(for_work),
mobility(sometimes),
difficulty_tasks(games_3D).

notebook('HP ProBook 640 G2') :-
target(for_work),
mobility(sometimes),
difficulty_tasks(office_application_internet_movies).

notebook('Dell Latitude') :-
target(for_work),
mobility(never),
difficulty_tasks(working_several_application).

notebook('Dell Latitude') :-
target(for_work),
mobility(never),
difficulty_tasks(movies_or_play_arcades).

notebook('Acer TravelMate') :-
target(for_work),
mobility(never),
difficulty_tasks(no_less_than_7_hours).

notebook('Lenovo ThinkPad P51s') :-
target(professional),
mobility(every_day),
battery(mail_news_social_network).

notebook('HP ZBook 14U G4') :-
target(professional),
mobility(every_day),
battery(movies_or_play_arcades).

notebook('ASUS ROG ZEPHYRUS') :-
target(professional),
mobility(every_day),
battery(no_less_than_7_hours).

notebook('Lenovo ThinkPad P51') :-
target(professional),
mobility(sometimes),
battery(mail_news_social_network).

notebook('HP ZBook 15 G3') :-
target(professional),
mobility(sometimes),
battery(movies_or_play_arcades).

notebook('MSI WS63') :-
target(professional),
mobility(sometimes),
battery(no_less_than_7_hours).

notebook('Lenovo ThinkPad P51s') :-
target(professional),
mobility(never),
battery(mail_news_social_network).

notebook('HP ZBook 17 G3') :-
target(professional),
mobility(never),
battery(movies_or_play_arcades).

notebook('MSI GE73VR') :-
target(professional),
mobility(never),
battery(no_less_than_7_hours).

notebook('MSI GE73') :-
target(games),
game_matrix(fast_matrix).

notebook('Dell Alienware A15 R3') :-
target(games),
game_matrix(high_quality_matrix).

notebook('Lenovo ThinkPad Yoga 370') :-
target(work_games),
difficulty_tasks(working_several_application),
battery(mail_news_social_network),
other_things(premium).

notebook('Acer Predator Helios 300 G3-572-515S') :-
target(work_games),
difficulty_tasks(working_several_application),
battery(mail_news_social_network),
other_things(backlit).

notebook('Apple MacBook 2017 MNYL2RU/A') :-
target(work_games),
difficulty_tasks(working_several_application),
battery(mail_news_social_network),
other_things(matrix).

notebook('Lenovo ThinkPad X1 Carbon 6') :-
target(work_games),
difficulty_tasks(working_several_application),
battery(mail_news_social_network),
other_things(body).

notebook('Dell Inspiron 7577') :-
target(work_games),
difficulty_tasks(working_several_application),
battery(movies_or_play_arcades),
other_things(premium).

notebook('Acer Swift SF314-52G-89YH') :-
target(work_games),
difficulty_tasks(working_several_application),
battery(movies_or_play_arcades),
other_things(backlit).

notebook('ASUS Zenbook 13 UX331UN-EG030R') :-
target(work_games),
difficulty_tasks(working_several_application),
battery(movies_or_play_arcades),
other_things(matrix).

notebook('HP EliteBook x360 1020 G2') :-
target(work_games),
difficulty_tasks(working_several_application),
battery(movies_or_play_arcades),
other_things(body).

notebook('ASUS ROG GL553VD-FY1114') :-
target(work_games),
difficulty_tasks(working_several_application),
battery(no_less_than_7_hours),
other_things(premium).

notebook('MSI GS65 8RF-069RU Stealth Thin') :-
target(work_games),
difficulty_tasks(working_several_application),
battery(no_less_than_7_hours),
other_things(backlit).

notebook('ASUS VivoBook Pro 15 N580VD-DM194T') :-
target(work_games),
difficulty_tasks(working_several_application),
battery(no_less_than_7_hours),
other_things(matrix).

notebook('MSI WS60 6QJ-020RU') :-
target(work_games),
difficulty_tasks(working_several_application),
battery(no_less_than_7_hours),
other_things(body).

notebook('Dell Alienware A15 R3') :-
target(work_games),
difficulty_tasks(games_3D),
battery(mail_news_social_network),
other_things(premium).

notebook('Acer Aspire 7 A715-71G-59UZ') :-
target(work_games),
difficulty_tasks(games_3D),
battery(mail_news_social_network),
other_things(backlit).

notebook('HP Pavilion Power 15-cb008ur') :-
target(work_games),
difficulty_tasks(games_3D),
battery(mail_news_social_network),
other_things(matrix).

notebook('Acer Predator Helios 300 G3-572-515S') :-
target(work_games),
difficulty_tasks(games_3D),
battery(mail_news_social_network),
other_things(body).

notebook('Acer Predator Helios 300 PH317-51-78Z8') :-
target(work_games),
difficulty_tasks(games_3D),
battery(movies_or_play_arcades),
other_things(premium).

notebook('Dell Inspiron 7577') :-
target(work_games),
difficulty_tasks(games_3D),
battery(movies_or_play_arcades),
other_things(backlit).

notebook('ASUS ROG SCAR Edition GL503VS-EI037T') :-
target(work_games),
difficulty_tasks(games_3D),
battery(movies_or_play_arcades),
other_things(matrix).

notebook('HP Omen 15-ce014ur') :-
target(work_games),
difficulty_tasks(games_3D),
battery(movies_or_play_arcades),
other_things(body).

notebook('HP Omen 17-an013ur') :-
target(work_games),
difficulty_tasks(games_3D),
battery(office_application_internet_movies),
other_things(premium).

notebook('MSI GS73 8RF-028RU Stealth') :-
target(work_games),
difficulty_tasks(games_3D),
battery(office_application_internet_movies),
other_things(backlit).

notebook('MSI GP62 8RD-052XRU World of Tanks Edition') :-
target(work_games),
difficulty_tasks(games_3D),
battery(office_application_internet_movies),
other_things(matrix).

notebook('ASUS ROG CHIMERA G703VI-E5132T') :-
target(work_games),
difficulty_tasks(games_3D),
battery(office_application_internet_movies),
other_things(body).

notebook('HP Pavilion 14-bf022ur') :-
target(work_games),
difficulty_tasks(office_application_internet_movies),
battery(mail_news_social_network),
other_things(premium).

notebook('ASUS Transformer 3 T305CA-GW014T PAD') :-
target(work_games),
difficulty_tasks(office_application_internet_movies),
battery(mail_news_social_network),
other_things(backlit).

notebook('Dell Vostro 5468') :-
target(work_games),
difficulty_tasks(office_application_internet_movies),
battery(mail_news_social_network),
other_things(matrix).

notebook('Apple MacBook 2017 MNYK2RU/A') :-
target(work_games),
difficulty_tasks(office_application_internet_movies),
battery(mail_news_social_network),
other_things(body).

notebook('HP 17-ak079ur') :-
target(work_games),
difficulty_tasks(office_application_internet_movies),
battery(movies_or_play_arcades),
other_things(premium).

notebook('HP 17-ak079ur') :-
target(work_games),
difficulty_tasks(office_application_internet_movies),
battery(movies_or_play_arcades),
other_things(backlit).

notebook('Lenovo ThinkPad X270') :-
target(work_games),
difficulty_tasks(office_application_internet_movies),
battery(movies_or_play_arcades),
other_things(matrix).

notebook('ASUS ROG GL702ZC-GC098T') :-
target(work_games),
difficulty_tasks(office_application_internet_movies),
battery(movies_or_play_arcades),
other_things(body).

notebook('ASUS Zenbook UX430UA-GV505R') :-
target(work_games),
difficulty_tasks(office_application_internet_movies),
battery(no_less_than_7_hours),
other_things(premium).

notebook('Lenovo IdeaPad 720S-13') :-
target(work_games),
difficulty_tasks(office_application_internet_movies),
battery(no_less_than_7_hours),
other_things(backlit).

notebook('Apple MacBook 2017 MNYK2RU/A') :-
target(work_games),
difficulty_tasks(office_application_internet_movies),
battery(no_less_than_7_hours),
other_things(matrix).

notebook('ASUS Zenbook UX310UQ-FC559T') :-
target(work_games),
difficulty_tasks(office_application_internet_movies),
battery(no_less_than_7_hours),
other_things(body).

%Вопросы к базе
question(target) :-
write('For what purpose do you need a laptop?'), nl.

question(mobility) :-
write('How often will you carry your laptop?'), nl.

question(difficulty_tasks) :-
write('How difficult tasks will your laptop solve?'), nl.

question(battery) :-
write('How long are you going to work on battery life?'), nl.

question(other_things) :-
write('Other things being equal, I will choose a laptop with the following characteristic'), nl.

question(game_matrix) :-
write('Do you want fast or high-quality matrix?'), nl.

question(brag_question) :-
write('What firm do you like?'), nl.