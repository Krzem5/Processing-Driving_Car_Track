class Track {
  PVector[][] edges;
  String fn;
  PVector ln;
  boolean md;
  int si;
  Track(String fn) {
    this.edges=this.from_file(fn);
    this.fn=fn;
    this.md=false;
    this.ln=new PVector(-1, -1);
    this.si=this.edges.length;
    println(this.si);
  }
  PVector[][] from_file(String fn) {
    JSONArray json=loadJSONArray(fn+".json");
    PVector[][] data=new PVector[json.size()][];
    for (int i=0; i<json.size(); i++) {
      PVector[] border=new PVector[json.getJSONArray(i).size()];
      JSONArray b=json.getJSONArray(i);
      for (int j=0; j<b.size(); j++) {
        JSONObject p=b.getJSONObject(j);
        border[j]=new PVector(p.getInt("x"), p.getInt("y"));
      }
      data[i]=border;
    }
    return data;
  }
  void save() {
    JSONArray json=new JSONArray();
    for (int i=0; i<this.edges.length; i++) {
      JSONArray border=new JSONArray();
      for (int j=0; j<this.edges[i].length; j++) {
        JSONObject p=new JSONObject();
        p.setInt("x", (int)this.edges[i][j].x);
        p.setInt("y", (int)this.edges[i][j].y);
        border.setJSONObject(j, p);
      }
      json.setJSONArray(i, border);
    }
    saveJSONArray(json, "./data/"+this.fn+".json");
  }
  void update() {
    if (mousePressed==true) {
      if (this.md==true) {
        this.ln.set(mouseX, mouseY);
      }
      if (this.md==false) {
        this.md=true;
        if (this.edges.length==0) {
          PVector[][] b={{new PVector(mouseX, mouseY)}};
          this.edges=b;
        }
        if (this.edges.length==this.si) {
          PVector[][] dt=new PVector[this.si+1][];
          for (int i=0; i<this.edges.length; i++) {
            PVector[] border=new PVector[this.edges[i].length];
            for (int j=0; j<this.edges[i].length; j++) {
              border[j]=new PVector(this.edges[i][j].x,this.edges[i][j].y);
            }
            dt[i]=border;
          }
          PVector[] b={new PVector(mouseX, mouseY)};
          dt[this.si]=b;
          this.edges=dt;
        }
        this.ln.set(mouseX, mouseY);
      }
    }
    if (mousePressed==false&&this.md==true) {
      this.md=false;
      PVector[] data=new PVector[this.edges[this.si].length+1];
      int i=0;
      for (i=0; i<this.edges[this.si].length; i++) {
        data[i]=this.edges[this.si][i];
      }
      data[i]=new PVector(this.ln.x, this.ln.y);
      this.edges[this.si]=data;
      this.ln=new PVector(-1, -1);
      this.save();
    }
  }
  void draw() {
    push();
    noFill();
    int i=0;
    for (PVector[] border : this.edges) {
      stroke(this.si==i?255:140);
      beginShape();
      for (PVector v : border) {
        vertex(v.x, v.y);
      }
      endShape((this.md==true&&i==this.si)?OPEN:CLOSE);
      if (this.md==true&&this.si==i) {
        line(this.ln.x, this.ln.y, border[border.length-1].x, border[border.length-1].y);
      }
      i++;
    }
    pop();
  }
}
