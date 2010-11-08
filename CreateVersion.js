function DateToVersionString(dtmDate){
   if (dtmDate == null){
      return "null date";
   }
   var Year, Month, Day;
   Year = dtmDate.getFullYear();
   Month = dtmDate.getMonth();
   Month = Month>9?Month:"0"+Month;
   Day = dtmDate.getDate();
   Day = Day>9?Day:"0"+Day;
   return (""+Year+Month+Day);
}

var fso = WScript.CreateObject("Scripting.FileSystemObject");
var fileOutVersion = fso.OpenTextFile("Version.txt", 2, true);
var fileOutVersionInc = fso.OpenTextFile("Version.inc", 2, true);
var fileInVersionPostfix = fso.OpenTextFile("VersionPostfix.inc", 1, false)
var VersionPostfix = "";
if (!fileInVersionPostfix.AtEndOfStream){
	VersionPostfix = fileInVersionPostfix.ReadAll();
};
var now = new Date();
var VersionString = DateToVersionString(now).substr(2, 6);
fileOutVersion.write(VersionString);
fileOutVersionInc.write("'" + VersionString + VersionPostfix + "'");



