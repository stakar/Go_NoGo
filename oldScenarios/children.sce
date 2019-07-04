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


# --- --- --- --- ---
# --- --- PCL --- ---
# --- --- --- --- ---

begin_pcl;

# wczytaj bodzce i przerwy
int quantityStimuli;

#quantityStimuli to ilosc bodzcow ogolnie; trzeba ja zmienic, jesli chcesz inna ilosc bodzcow
quantityStimuli = 138;

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

#Ponizej jest przygotwoanie bodzcow no-go

loop
	int i = 1
until
#trzeba zmienic ponizsza wartosc i by ustalic ile ma byc bodzcow no-go
	i > 46
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
array<string>no_go_names[]={"ng1","ng2","ng3"};


array<int> no_go_objects[] = {0, 1, 2, 3, 0, 3, 2, 1};    # cyfry no-go dla każdego bloku

###############################
#Instrukcja na początku badania
###############################

#####################
#Prezentacja bodźców#
#####################
int y = 0;
string name_trial_go = "t_";
string name_trial_no_go = "t_";
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
	t > 10
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
		
		#Zaprezentuj znak NO-GO 
		if znak == no_go then
			graphics_no_go[current_go].load();
			stimuli_no_go.set_part(1,graphics_no_go[current_go]);
			cyfra_stimev.set_stimulus(stimuli_no_go);
			cyfra_stimev.set_target_button(0);
			cyfra_stimev.set_response_active(true);
			cyfra_stimev.set_event_code(no_go_names[current_go])

		#Zaprezentuj znaj GO
		else
			graphics_go[current_go].load();
			stimuli_go.set_part(1,graphics_go[current_go]);
			cyfra_stimev.set_stimulus(stimuli_go);
			cyfra_stimev.set_target_button(1);
			cyfra_stimev.set_event_code(go_names[current_go]);
		end;
		
		my_trial.set_duration(przerwa + 250);
		my_trial.present();
		t = t + 1;
	end;
	blok = blok + 1
end;
# zakończenie
koniec_trial.present();
