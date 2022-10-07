/* ALPHA VERSION V 1.2 24/9/22
 * Written by Will Hastings/ Aidan Milston
 * Macro to read magnification from metadata of a DM3, add an appropriate sized scale bar and export as 32 bit TIFF and 8 bit JPG.
 * Make DM3, JPG and TIFF folders in the same directory.
 * Currently supported mags:
 *				12kx  - 500nm Scale bar
 *				15kx  - 500nm Scale bar
 *				20kx  - 500nm Scale bar
 *              25kx  - 500nm Scale bar
 *				40kx  - 500nm Scale bar
 *				50kx  - 200nm Scale bar
 *				60kx  - 200nm Scale bar
 *				80kx  - 100nm Scale bar
 *				100kx - 100nm Scale bar
 *				120kx - 100nm Scale bar
 *				150kx - 100nm Scale bar
 *				200kx -  50nm Scale bar
 */

input = getDirectory("Select Input directory");
outputT = input + File.separator + "TIFF";
outputJ = input + File.separator + "JPG";

gen_folders(outputT, outputJ);
processFolder(input, outputT, outputJ);

function gen_folders(outputT, outputJ) {
	if (! File.exists(outputT)){
		File.makeDirectory(outputT);
	}
	if (! File.exists(outputJ)){
		File.makeDirectory(outputJ);
	}
}

function processFolder(input, outputT, outputJ) {
	suffix = ".dm3";
	list = getFileList(input);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + list[i]))
			processFolder("" + input + list[i],outputT, outputJ);
		if(endsWith(list[i], suffix))
			processFile(input, outputT, outputJ, list[i]);
	}
}

function processFile(input, outputT, outputJ, file) {
	open(input + file);
	selectWindow(file);
	string = Property.getInfo();
	array = split(string, "\n");
	temp = Array.filter(array, "Indicated Magnification");
	mag = substring(temp[0], 69);	

	if (mag == "12000.0"){
	size=2;} 
	else if (mag == "15000.0"){
	size=500;}
	else if (mag == "20000.0"){
	size=500;}
	else if (mag == "25000.0"){
	size=500;}
	else if (mag == "40000.0"){
	size=200;}
	else if (mag == "50000.0"){
	size=200;}
	else if (mag == "60000.0"){
	size=200;}
	else if (mag == "80000.0"){
	size=100;}
	else if (mag == "100000.0"){
	size=100;}
	else if (mag == "120000.0"){
	size=100;}
	else if (mag == "150000.0"){
	size=100;}
	else if (mag == "200000.0"){
	size=50;}
	else {
		size=0;
	} 
	AnalyseImage(size);
	
	newfile = File.getNameWithoutExtension(file);
	
	if (size !=0) {
		print(newfile, "saved.");
		saveAs("TIFF", outputT + File.separator + newfile + ".tiff");
		saveAs("jpg", outputJ +File.separator + newfile + ".jpg");
	}
	else {print(newfile, "skipped, unsupported magnification of",mag);}
	close();
}

function AnalyseImage(size){
	makeRectangle(50, 3796, 1200, 250);
	LL = getValue("Mean");
	
	makeRectangle(2846, 3796, 1200, 250);
	LR = getValue("Mean");
	
	makeRectangle(50, 0, 1200, 250);
	UL = getValue("Mean");
	
	makeRectangle(2846, 0, 1200, 250);
	UR = getValue("Mean");
	
	makeRectangle(0,0,0,0);

	calculate(UL,UR,LL,LR,size);
}
function calculate(UL, UR, LL, LR, size) {
	
	array1 = newArray(UL, UR, LL, LR);
	min_val = Array.findMinima(array1, 0);

	if (min_val[0] == 0){
		placement = "Upper Left";
	}
	else if (min_val[0] == 1){
		placement = "Upper Right";
	}
	else if (min_val[0] == 2){
		placement = "Lower Left";
	}
	else if (min_val[0] == 3){
		placement = "Lower Right";
	}
	addScaleBar(size, placement);
}

function addScaleBar(size, placement) {

	if (size >1) {
		run("Scale Bar...", "width=size height=40 font=90 color=White background=None location=[&placement] bold");
	}
	else {}
}