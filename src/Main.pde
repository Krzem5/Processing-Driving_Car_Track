Track track;
void setup() {
  size(800, 800);
  track=new Track("track_data");
}
void draw() {
  background(0);
  track.update();
  track.draw();
}
