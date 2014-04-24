package;


import flash.display.Sprite;
import flash.display.MovieClip;
import flash.display.Graphics;
import flash.display.Shape;
import flash.geom.ColorTransform;

import Point;


class Node extends Sprite {
	
	public var g:Float = 0;
	public var h:Float = 0;
	public var f:Float = 0;

	public var code:Int = 0;

	public var parentNode:Node;

	public var costumWidth:Int = 50;
	public var costumHeight:Int = 50;


	public var baris:Int = 0;	//posisi baris 
	public var kolom:Int = 0;	//posisi kolom

	//array yang menampung node-node di sebelahnya
	public var nodeArr:Array<Node>;

	static var mc:MovieClip;

	var figures:Shape;
	var lineFigure:Shape;
	var grp:Graphics; 

	//konstanta untuk g
	var G_LURUS:Float = 10;
	var G_DIAGONAL:Float = 14;

	// 0 = empty node
	// 1 = wall
	// 2 = start
	// 3 = target finish
	public var nodeType:Int;


	public function new(){
		super();
		
		figures = new Shape();
		grp = figures.graphics;

		nodeArr = new Array<Node>();

		//draw the square
		grp.beginFill(0x000000, 1);
		grp.drawRect(0,0, costumWidth, costumHeight);
		grp.endFill();
		addChild(figures);

		lineFigure = new Shape();
		var lineGrp:Graphics = lineFigure.graphics;
		lineGrp.lineStyle(1, 0xFFFFFF);
		lineGrp.drawRect(0,0, costumWidth, costumHeight);
		addChild(lineFigure);

	}


	public function changeColor(color:UInt){
		var colTrans:ColorTransform = new ColorTransform();
		colTrans.color = color;
		figures.transform.colorTransform = colTrans;
	}


	public function updateG(parentBaris:Int, parentKolom:Int, parentG:Float){


			//delta
			var dBaris:Int = this.baris-parentBaris;
			var dKolom:Int = this.kolom-parentKolom;
			
			var gTambah:Float = 0;
			//cek posisi
			//n
			if(dBaris == -1 && dKolom == 0){
				gTambah = G_LURUS;
			//ne
			}else if(dBaris == -1 && dKolom == 1){
				gTambah= G_DIAGONAL;
			//e
			}else if(dBaris == 0 && dKolom == 1){
				gTambah = G_LURUS;
			//se
			}else if(dBaris == 1 && dKolom == 1){
				gTambah = G_DIAGONAL;
			//s
			}else if(dBaris == 1 && dKolom == 0){
				gTambah = G_LURUS;
			//sw
			}else if(dBaris == 1 && dKolom == -1){
				gTambah = G_DIAGONAL;
			//w
			}else if(dBaris == 0 && dKolom == -1){
				gTambah = G_LURUS;
			//nw
			}else if(dBaris == -1 && dKolom == -1){
				gTambah = G_DIAGONAL;
			}
			g = parentG+gTambah;

			updateF();


	}



	
	public function updateH(endBaris:Int, endKolom:Int){

		var distance:Int = Std.int(Math.abs(kolom-endKolom) + Math.abs(baris-endBaris));

		this.h = distance;

		updateF();

	}

	public function updateF(){
		this.f = this.g + this.h;
	}


}
