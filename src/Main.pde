Track t;



void setup(){
	size(800,800);
	t=new Track("track_data");
}
void draw(){
	background(0);
	t.update();
	t.draw();
}
