active_buttons = 2;
response_matching = simple_matching;
default_font_size = 160;
default_background_color = 222, 222, 222;
default_text_color = 25, 25, 25;
begin;

# ponizej zdefiniowane obiekty będą
# modyfikowane z poziomu PCL

# --- obiekty text ---
text {caption = "GO"; 
		font = "Times New Roman";} cyfra_txt;

text {
	caption = "No-Go";
	font = "Times New Roman";
	font_size = 96;
} no_go_txt;

text {
	caption = "Go";
	font = "Times New Roman";
	font_size = 48;
} go_txt;


# --- bitmap section ---

bitmap {filename = "rakieta.png";} go_stimuli_pic;
bitmap {filename = "ufo.png";} no_go_stimuli_pic;

array{
	bitmap {filename = "rakieta.png"; preload = false; }; 
	bitmap {filename = "star_go.png";	 preload = false; };
	bitmap {filename = "car1_go.png"; preload = false; };
} graphics_go;

array{
	bitmap {filename = "ufo.png"; 	preload = false;	};
	bitmap {filename = "heart_no_go.png";	 preload = false; };
	bitmap {filename = "car1_no_go.png";	 preload = false; };
} graphics_no_go;

# --- obiekty picture ---




picture { 
	# instrukcja na początek bloku
#	text{caption = "Witaj w badaniu. Zapoznaj się z bodźcami. \n Kiedy będziesz gotowy, kliknij spację";
#		font = "Times New Roman";
#		font_size = 36;
#	};
#	x = 0; y = 340;
	text{
		caption = "Nie klikaj na znak";
		font = "Times New Roman";
		font_size = 48;
	};
	x = -400; y = 170;
	
	text{
		caption = "Klikaj na znak";
		font = "Times New Roman";
		font_size = 48;
	};
	x = 400; y = 170;

	
} instrukcja_blok_pic;

picture {
	# koniec pierwszej części
	text{
		caption = "To już koniec";
		font = "Times New Roman";
		font_size = 48;
	};
	x = 0; y=0;
} koniec_pic;
	
picture {
	#Pierwszy obrazek - znak GO
	background_color = 222, 222, 222;
} znak_pic_go;

picture {
	background_color = 222, 222, 222;
} znak_pic_no_go;


picture{} blank; # pusty ekran

 picture {  
      # placeholder - set by PCL
      box { height = 1; width = 1; color = 0,0,0; };
      x = 0; y = 0;
   } stimuli_go;

 picture {  
      # placeholder - set by PCL
      box { height = 1; width = 1; color = 0,0,0; };
      x = 0; y = 0;
   } stimuli_no_go;


picture {
	# feedback - zysk za blok
	text{
		caption = "Twoja strata w bloku";
		font = "Times New Roman";
		font_size = 48;
	};
	x = 0; y = 100;
	
	text{
		caption = "0 Euro 0 Cent";
		font = "Times New Roman";
		font_size = 48;
	} zysk_txt;
	x = 0; y = 0;
	
	text{
		caption = "(Übrig geblieben: 0 Euro 0 Cent)";
		font = "Times New Roman";
		font_size = 48;
	} zysk_do_tej_pory_txt;
	x = 0; y = -150;
	
} feedback_pic;


# ---------------------
# --- obiekty trial ---
# ---------------------


trial{
	# instrukcja na początek bloku
	all_responses = true;
	trial_duration = 3000000;
	trial_type = specific_response;
	terminator_button = 2;
	
	picture instrukcja_blok_pic; 
#	time = 0; duration = 12500;
	
#	picture blank;
#	time = 1250; duration = 1000;
} instrukcja_blok_trial;

trial{
	picture blank;
	time = 1250; duration = 1000;
		}blank_trial;

trial{
	# koniec pierwszej części
	trial_duration = 50000;
	picture koniec_pic;
} koniec_trial;

	
trial{
	# głowny trial - wyswietlenie cyfry
	
	trial_duration = 1250;
	
	stimulus_event{
		picture znak_pic_go;
		time = 0;
		duration = 250;
		code = "xxx";
	} cyfra_stimev;
	
	picture blank;
	time = 250;
	
}my_trial;



trial{
	# feedback - zysk za blok
	trial_duration = 10000;
	picture feedback_pic;
} feedback_blok_trial;




# --- --- --- --- ---
# --- --- PCL --- ---
# --- --- --- --- ---

begin_pcl;




sub
	string zysk_w_zlotych(int grosze)
begin
	int gr = 1;
	if	(grosze >= 0 && grosze <= 14) then
		gr = 1;
	end;
	if	(grosze >= 15 && grosze <= 29) then
		gr = 2;
	end;
	if	(grosze >= 30 && grosze <= 44) then
		gr = 3;
	end;
	if	(grosze >= 45 && grosze <= 59) then
		gr = 4;
	end;
	if	(grosze >= 60 && grosze <= 74) then
		gr = 5;
	end;
	if	(grosze >= 75 && grosze <= 89) then
		gr = 6;
	end;
	if	(grosze >= 90 && grosze <= 104) then 
		gr = 7;
	end;
	if	(grosze >= 105 && grosze <= 119) then
		gr = 8;
	end;
	if	(grosze >= 120 && grosze <= 134) then
		gr = 9;
	end;
	if	(grosze >= 135 && grosze <= 150) then
		gr = 10;
	end;
	
	string zwz = string(gr);
	return zwz;
end;


# deklaracje zmiennych - liczenie zysku / straty
stimulus_data last;
int zysk_total = 0; # początkowa kwota (gr) - to przy karach 4/16 gr
int strata_blok;
string komunikat_o_zysku;

# wczytaj bodzce i przerwy

int quantityStimuli;
quantityStimuli = 90;


array<string> stimSign[quantityStimuli];
array<int> przerwy[quantityStimuli];
input_file in2 = new input_file;
string go;
go = "GO";
string no_go;
no_go = "NO_GO";

in2.open("przerwy_ms.txt");
loop
	int i = 1
until
	i > quantityStimuli
begin
	przerwy[i] = in2.get_int();
	i = i+1;
end;

# przygotowanie bodzcow

loop
	int i = 1
until
	i > quantityStimuli
begin
	stimSign[i] = go;
	i = i + 1;
end;

loop
	int i = 1
until
	i > 30
begin
	int which;
	which = random(1,quantityStimuli);
	if stimSign[which] != no_go then
		stimSign[which] = no_go;
		i = i + 1;
	end;
end;

in2.close();

# deklaracje zmiennych
int fontNumber;
int stimNumber = 1;
string znak;
int current_go;
int przerwa;

array<string>go_names[]={"go1","go2","go3"};
array<string>no_go_names[]={"no_go1","no_go2","no_go3"};


array<int> no_go_objects[] = {0, 1, 2, 3, 0, 3, 2, 1};    # cyfry no-go dla każdego bloku

################################
#Instrukcja na początku badania#
################################

#####################
#Prezentacja bodźców#
#####################
int y = 0;
string name_trial_go = "trial_";
string name_trial_no_go = "trial_";
array<int> proba[] = {1,2,3};

proba.shuffle();
y = proba[1];

name_trial_go.append(go_names[y]);

name_trial_no_go.append(no_go_names[y]);

graphics_go[y].load();
graphics_no_go[y].load();
instrukcja_blok_pic.add_part(graphics_no_go[y],-400,-180);
instrukcja_blok_pic.add_part(graphics_go[y ],400,-180);
instrukcja_blok_trial.present();
blank_trial.present();

loop 
	int t = 1
until
	t > 1
begin
	
	# weź znak i długość przerwy
	znak = stimSign[stimNumber];
	
	cyfra_txt.set_caption(znak);
	cyfra_txt.redraw();
	przerwa = przerwy[stimNumber];
	stimNumber = stimNumber + 1;
	
	#Zaprezentuj znak NO-GO 
	if znak == no_go then
		graphics_no_go[y].load();
		stimuli_no_go.set_part(1,graphics_no_go[y]);
		cyfra_stimev.set_stimulus(stimuli_no_go);
		cyfra_stimev.set_target_button(0);
		cyfra_stimev.set_response_active(true);
		cyfra_stimev.set_event_code(name_trial_no_go);
	#Zaprezentuj znaj GO
	else
		graphics_go[y].load();
		stimuli_go.set_part(1,graphics_go[y]);
		cyfra_stimev.set_stimulus(stimuli_go);
		cyfra_stimev.set_target_button(1);
		cyfra_stimev.set_event_code(name_trial_go);
	end;
	
	my_trial.set_duration(przerwa + 250);
	my_trial.present();
	t = t + 1;
end;

stimSign.shuffle();

loop 
	int blok = 1
until
	blok > 3
begin
	
	current_go = blok;
	graphics_go[current_go].load();
	graphics_no_go[current_go].load();
	instrukcja_blok_pic.add_part(graphics_no_go[current_go],-400,-180);
	instrukcja_blok_pic.add_part(graphics_go[current_go],400,-180);
	instrukcja_blok_trial.present();
	blank_trial.present();
	
	stimNumber = 1;
	loop 
		int t = 1
	until
		t > (quantityStimuli-1)
		#t > 2
	begin
		
		# weź znak i długość przerwy
		znak = stimSign[stimNumber];
		
		cyfra_txt.set_caption(znak);
		cyfra_txt.redraw();
		przerwa = przerwy[stimNumber];
		stimNumber = stimNumber + 1;
		
		#Zaprezentuj znak GO 
		if znak == no_go then
			graphics_no_go[current_go].load();
			stimuli_no_go.set_part(1,graphics_no_go[current_go]);
			cyfra_stimev.set_stimulus(stimuli_no_go);
			cyfra_stimev.set_target_button(0);
			cyfra_stimev.set_response_active(true);
			cyfra_stimev.set_event_code(no_go_names[current_go])

		#Zaprezentuj znaj NO-GO
		else
			graphics_go[current_go].load();
			stimuli_go.set_part(1,graphics_go[current_go]);
			cyfra_stimev.set_stimulus(stimuli_go);
			cyfra_stimev.set_target_button(1);
			cyfra_stimev.set_event_code(go_names[current_go]);
		end;
		
		my_trial.set_duration(przerwa + 250);
		my_trial.present();
		
				# policz stratę (jeśli jest)
		last = stimulus_manager.last_stimulus_data();
		# MISS - pominięte go, false_alarm - wciśnięcie no-go
		if last.type() == last.MISS then
			strata_blok = strata_blok + 1;
		elseif last.type() == last.FALSE_ALARM then
			strata_blok = strata_blok + 3;
			# dla OTHER reaction_time() zwraca 0
			# więc ma szansę się wykonać tylko dla HIT
		end;
		
		t = t + 1;
	end;
	int zysk_w_bloku = 150-strata_blok;
	# policz gratyfikację
	zysk_total = zysk_total + zysk_w_bloku;

	# wyświetl stratę
	komunikat_o_zysku = zysk_w_zlotych(zysk_w_bloku);
	zysk_txt.set_caption("Zdobyłeś " + komunikat_o_zysku + " naklejek");
	zysk_txt.redraw();
	komunikat_o_zysku = "(Twój zysk w naklejkach ogółem : " + zysk_w_zlotych(zysk_total) + ")";
	zysk_do_tej_pory_txt.set_caption(komunikat_o_zysku);
	zysk_do_tej_pory_txt.redraw();
	feedback_blok_trial.present(); # feedback_trial
	blok = blok + 1
end;
# zakończenie
koniec_trial.present();