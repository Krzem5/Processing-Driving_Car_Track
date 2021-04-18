class Track{
	PVector[][] el;
	String fn;
	PVector ln;
	boolean md;
	int si;



	Track(String fn){
		this.el=this.from_file(fn);
		this.fn=fn;
		this.md=false;
		this.ln=new PVector(-1,-1);
		this.si=this.el.length;
	}



	void update(){
		if (mousePressed==true){
			if (this.md==true){
				this.ln.set(mouseX,mouseY);
			}
			if (this.md==false){
				this.md=true;
				if (this.el.length==0){
					PVector[][] b={{new PVector(mouseX,mouseY)}};
					this.el=b;
				}
				if (this.el.length==this.si){
					PVector[][] dt=new PVector[this.si+1][];
					for (int i=0; i<this.el.length; i++){
						PVector[] border=new PVector[this.el[i].length];
						for (int j=0; j<this.el[i].length; j++){
							border[j]=new PVector(this.el[i][j].x,this.el[i][j].y);
						}
						dt[i]=border;
					}
					PVector[] b={new PVector(mouseX,mouseY)};
					dt[this.si]=b;
					this.el=dt;
				}
				this.ln.set(mouseX,mouseY);
			}
		}
		if (mousePressed==false&&this.md==true){
			this.md=false;
			PVector[] data=new PVector[this.el[this.si].length+1];
			int i=0;
			for (i=0; i<this.el[this.si].length; i++){
				data[i]=this.el[this.si][i];
			}
			data[i]=new PVector(this.ln.x,this.ln.y);
			this.el[this.si]=data;
			this.ln=new PVector(-1,-1);
			this.save();
		}
	}



	void draw(){
		push();
		noFill();
		int i=0;
		for (PVector[] border:this.el){
			stroke(this.si==i?255:140);
			beginShape();
			for (PVector v:border){
				vertex(v.x,v.y);
			}
			endShape((this.md==true&&i==this.si)?OPEN:CLOSE);
			if (this.md==true&&this.si==i){
				line(this.ln.x,this.ln.y,border[border.length-1].x,border[border.length-1].y);
			}
			i++;
		}
		pop();
	}



	PVector[][] from_file(String fn){
		JSONArray json=loadJSONArray(fn+".json");
		PVector[][] data=new PVector[json.size()][];
		for (int i=0; i<json.size(); i++){
			PVector[] border=new PVector[json.getJSONArray(i).size()];
			JSONArray b=json.getJSONArray(i);
			for (int j=0; j<b.size(); j++){
				JSONObject p=b.getJSONObject(j);
				border[j]=new PVector(p.getInt("x"),p.getInt("y"));
			}
			data[i]=border;
		}
		return data;
	}



	void save(){
		JSONArray json=new JSONArray();
		for (int i=0; i<this.el.length; i++){
			JSONArray border=new JSONArray();
			for (int j=0; j<this.el[i].length; j++){
				JSONObject p=new JSONObject();
				p.setInt("x",(int)this.el[i][j].x);
				p.setInt("y",(int)this.el[i][j].y);
				border.setJSONObject(j,p);
			}
			json.setJSONArray(i,border);
		}
		saveJSONArray(json,"data/"+this.fn+".json");
	}
}
