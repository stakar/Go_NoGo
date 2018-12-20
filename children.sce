active_buttons = 1;
response_matching = simple_matching;
default_all_responses = false;
default_font_size = 160;
default_background_color = 222, 222, 222;
default_text_color = 25, 25, 25;

begin;

# poniżej zdefiniowane obiekty będą
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


# --- obiekty picture ---

picture {
	#Pierwszy obrazek - znak GO
	background_color = 222, 222, 222;
	bitmap go_stimuli_pic;
	x=0; y=0;
} znak_pic_go;

picture {
	background_color = 222, 222, 222;
	bitmap no_go_stimuli_pic;
	x=0;y=0;
} znak_pic_no_go;


picture { 
	# instrukcja na początek bloku
	text{
		caption = "nie reaguj na znak";
		font = "Times New Roman";
		font_size = 48;
	};
	x = -300; y = 180;
	
	text{
		caption = "reaguj na znak";
		font = "Times New Roman";
		font_size = 48;
	};
	x = 300; y = 180;

	bitmap no_go_stimuli_pic; x = -300; y = -180;
	bitmap go_stimuli_pic; x = 300; y = -180;
	
} instrukcja_blok_pic;

picture {
	# koniec pierwszej części
	text{
		caption = "To już koniec pierwszej części";
		font = "Times New Roman";
		font_size = 48;
	};
	x = 0; y=0;
} koniec_pic;


picture{} blank; # pusty ekran


# ---------------------
# --- obiekty trial ---
# ---------------------


trial{
	# instrukcja na początek bloku
	#trial_duration = 30000;
	trial_duration = 3000;
	
	picture instrukcja_blok_pic;
	time = 0; duration = 2500;
	
	picture blank;
	time = 2500; duration = 300;
	
} instrukcja_blok_trial;

trial{
	# koniec pierwszej części
	trial_duration = 5000;
	picture koniec_pic;
} koniec_trial;

	
trial{
	# główny trial - wyświetlenie cyfry
	
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

# wczytaj bodźce i przerwy
int quantityStimuli;
quantityStimuli = 120;
array<string> stimSign[quantityStimuli];
array<int> przerwy[quantityStimuli];
input_file in2 = new input_file;
string go;
go = "GO";
string no_go;
no_go = "NO_GO";

go_stimuli_pic.load();
no_go_stimuli_pic.load();


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
	i > 40
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
string current_no_go;
int przerwa;

#Instrukcja na początku badania

instrukcja_blok_trial.present();

#Prezentacja bodźców

loop 
	int t = 1
until
	t > 120
begin
	
	# weź znak i długość przerwy
	znak = stimSign[stimNumber];
	
	cyfra_txt.set_caption(znak);
	cyfra_txt.redraw();
	przerwa = przerwy[stimNumber];
	stimNumber = stimNumber + 1;
	
	#Zaprezentuj znak GO 
	if znak == "GO" then
		# no-go
		cyfra_stimev.set_stimulus(znak_pic_go);
		cyfra_stimev.set_target_button(0);
		cyfra_stimev.set_response_active(true);
		cyfra_stimev.set_event_code("no-go")
	#Zaprezentuj znaj NO-GO
	else
		# go
		cyfra_stimev.set_stimulus(znak_pic_no_go);
		cyfra_stimev.set_target_button(1);
		cyfra_stimev.set_event_code("go")
	end;
	
	my_trial.set_duration(przerwa + 250);
	my_trial.present();
	t = t + 1;
end;

# zakończenie
koniec_trial.present();