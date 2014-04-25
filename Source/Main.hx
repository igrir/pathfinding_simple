package;


import flash.display.Sprite;
import Node;

class Main extends Sprite {

	// 0 = kosong
	// 1 = dinding
	// 2 = awal
	// 3 = target

	public var nodeArr:Array<Array<Int>> = [[0,0,0,0,0,0,0,0],
	       					[0,0,0,0,1,0,0,0],
						[0,0,2,0,1,0,3,0],
						[0,0,0,0,1,0,0,0],
						[0,0,0,0,0,0,0,0],
						[0,0,0,0,0,0,0,0]
						];
	

	public var nodeObjArr:Array<Array<Node>>;

	public function new () {
		
		super ();

		nodeObjArr = new Array<Array<Node>>();

		initBoard();
		aStar();
		
		
	}

	public function initBoard(){

		for (i in 0...nodeArr.length) {

			var nodeObjRow:Array<Node> = new Array<Node>();

			for (j in 0...nodeArr[0].length) {

				//buat node
				var node:Node = new Node();
				node.x = j * node.costumWidth;
				node.y = i * node.costumHeight;


				node.baris = i;
				node.kolom = j;

				addChild(node);

				nodeObjRow.push(node);

				//atur kondisi berdasarkan array yang ada di dalamnya
				var nodeCode:Int = nodeArr[i][j];

				if (nodeCode == 0) {	//kosong
					node.changeColor(0x000000);
				}else if(nodeCode == 1){		//dinding

					node.changeColor(0x00FF00);

				}else if(nodeCode == 2){		//awal

					node.changeColor(0xFF0000);

				}else if(nodeCode == 3){		//target

					node.changeColor(0x0000FF);

				}

				node.code = nodeCode;
			}

			nodeObjArr.push(nodeObjRow);

		}

	}

	
	public function getNodeByCode(code:Int):Node{


		var i:Int = 0;
		var j:Int = 0;

		var found:Bool = false;

		var returnNode:Node = null;
		var currentNode:Node = null;

		while (i < nodeObjArr.length &&
		       j < nodeObjArr[0].length &&
		       !found) {

			currentNode = nodeObjArr[i][j];	

			if (currentNode.code == code) {
				returnNode = nodeObjArr[i][j];	
				found = true;
			}else{
				if (j+1 < nodeObjArr[0].length) {
					j++;
				}else{
					i++;
					j = 0;
				}
			}


		}
		
		
		return returnNode;

	}


	public function aStar(){


		var openList:Array<Node> = new Array<Node>();
		var closedList:Array<Node> = new Array<Node>();

		var startNode:Node = getNodeByCode(2); 
		var endNode:Node = getNodeByCode(3);

		var found:Bool = false;

		openList.push(startNode);

		while (openList.length != 0 && !found) {

			var currentNode:Node = openList[0];

			//cari node paling kecil f nya
			var lowestFNode:Node = openList[0];
			for (node in openList) {
				if (node.f < lowestFNode.f) {
					lowestFNode = node;
				}
			}

			currentNode = lowestFNode;

			//lakukan jika bukan end node
			if (currentNode != endNode) {

				//currentNode.changeColor(0xFFFFFF);

				var neighbourList:Array<Node> = new Array<Node>();

				//lihat sekeliling
				for (y in -1...2) {
					for (x in -1...2) {

						if (y != 0 || x != 0) {

							var rowNeighbour = currentNode.baris + y;
							var colNeighbour = currentNode.kolom + x;
							

							if (rowNeighbour < nodeArr.length &&
							rowNeighbour >= 0 &&
							colNeighbour < nodeArr[0].length &&
							colNeighbour >= 0 &&
							nodeArr[rowNeighbour][colNeighbour] != 1  //bukan dinding
							) {

								var neighbourNode:Node = nodeObjArr[rowNeighbour][colNeighbour];

								if (openList.indexOf(neighbourNode) == -1 &&
								    closedList.indexOf(neighbourNode) == -1){

									//trace("Masukin");
									openList.push(neighbourNode);

									neighbourNode.parentNode = currentNode;
									neighbourList.push(neighbourNode);
									
									neighbourNode.updateG(currentNode.baris, currentNode.kolom, currentNode.g); 
									neighbourNode.updateH(endNode.baris, endNode.kolom);
								}else{
								}
							}

						}

					}
				}


				if (neighbourList.length > 0) {

					//select the smallest node
					var smallestNode:Node = neighbourList[0];
					for (neighbourNode in neighbourList) {

						//inisialisasi
				
						//trace(neighbourNode.f + "<" + smallestNode.f + "?");
						
						if (neighbourNode.f < smallestNode.f) {
							smallestNode = neighbourNode;
						}
					

					}



				//lihat sekeliling
				for (y in -1...2) {
					for (x in -1...2) {

						if (y != 0 || x != 0) {

							var rowNeighbour = currentNode.baris + y;
							var colNeighbour = currentNode.kolom + x;
							

							if (rowNeighbour < nodeArr.length &&
							rowNeighbour >= 0 &&
							colNeighbour < nodeArr[0].length &&
							colNeighbour >= 0 &&
							nodeArr[rowNeighbour][colNeighbour] != 1  //bukan dinding
							) {

								var neighbourNode:Node = nodeObjArr[rowNeighbour][colNeighbour];
								//gak ada di closed list
								if (closedList.indexOf(neighbourNode) == -1 &&
								    openList.indexOf(neighbourNode) != -1) {
									if (neighbourNode.g+neighbourNode.getTargetG(smallestNode.baris, smallestNode.kolom) < smallestNode.g) {

										trace("change way");
										//ini kok salah ya?
										neighbourNode.parentNode = currentNode;

										neighbourNode.updateG(neighbourNode.parentNode.baris, neighbourNode.parentNode.kolom, neighbourNode.parentNode.g); 
										neighbourNode.updateH(endNode.baris, endNode.kolom);

									}

								}
								
							}

						}

					}
				}


				


				}
				
				closedList.push(currentNode);
				openList.remove(currentNode);

			}else{
				found = true;
				trace("found");
			}

			
		}

		//parent node
		var backtrackNode:Node = endNode.parentNode;

		while(backtrackNode.parentNode != startNode){
			backtrackNode.changeColor(0xFFFFFF);
			backtrackNode = backtrackNode.parentNode;
		}

			backtrackNode.changeColor(0xFFFFFF);

	}
	
	
}
