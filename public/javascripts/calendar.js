var first = "", lfirst = "";
var last = "", llast = "";
var MS_IN_DAY = 24 * 60 * 60 * 1000;


clearCurrent = function()
{
  paintRange(lfirst,llast, "calbox");
}

paintCurrent = function()
{
  paintRange(lfirst,llast, "calbox dark");
}

paintRange = function(a,b,cl)
{
  if (a!="" && b!= "")
  {
    for (var i = a; i <= b; i++)
    {
      document.getElementById(i).className = cl;
    }
  }

}

show = function(id)
{
  var d = new Date();
  d.setTime(id*MS_IN_DAY);

  paintCurrent();
  
  if (first=="")
  {
    document.getElementById(id).innerHTML = d.getDate();
    document.getElementById(id).className = "calbox link";
  }
  else
  {
    paintRange(first,id,"calbox link");
    document.getElementById(id).innerHTML = d.getDate();
  }
}

hide = function(id)
{
  document.getElementById(id).innerHTML = '&nbsp;';
  if (first=="")
  {
    if (lfirst == "" || id < lfirst || id > llast)
      document.getElementById(id).className = "calbox";
  }
  else
  {
    for (var i = first; i <= id; i++)
    {
      document.getElementById(i).className = "calbox";
    }
    document.getElementById(first).className = "calbox link";
  }
}
click = function(id)
{
//  document.getElementById(id).innerHTML = 'X';
  var d = new Date();
  d.setTime(id*MS_IN_DAY);

  if (first=="")
  {
    clearCurrent();
    lfirst = "";
    llast = "";
    first = id;
    setStartDate(d.getFullYear(), d.getMonth()+1, d.getDate());
    clearEndDate();
  }
  else
  {
    clearCurrent();
    lfirst = first;
    llast = id;
    paintCurrent();
    if (first != id)
    {
      setEndDate(d.getFullYear(), d.getMonth()+1, d.getDate());
    }
    first = "";
  }
}
setStartDate = function(y,m,d)
{
  firstyear = document.forms[0].elements['userplace[start_date(1i)]'].options[1].value;
  document.forms[0].elements['userplace[start_date(1i)]'].selectedIndex = firstyear-y+1;
  document.forms[0].elements['userplace[start_date(2i)]'].selectedIndex = m;
  document.forms[0].elements['userplace[start_date(3i)]'].selectedIndex = d;
}
setEndDate = function(y,m,d)
{
  firstyear = document.forms[0].elements['userplace[end_date(1i)]'].options[1].value;
  document.forms[0].elements['userplace[end_date(1i)]'].selectedIndex = firstyear-y+1;
  document.forms[0].elements['userplace[end_date(2i)]'].selectedIndex = m;
  document.forms[0].elements['userplace[end_date(3i)]'].selectedIndex = d;
}
clearEndDate = function()
{
  document.forms[0].elements['userplace[end_date(1i)]'].selectedIndex = 0
  document.forms[0].elements['userplace[end_date(2i)]'].selectedIndex = 0;
  document.forms[0].elements['userplace[end_date(3i)]'].selectedIndex = 0;
}

relativeDate = function(date, offset, dateType)
{

  if (offset == 0) return;

  var tripstart = new Date();
  tripstart.setTime(date*MS_IN_DAY);

  var offset = (offset - 1) * MS_IN_DAY;
  var thisdate = new Date(+tripstart.valueOf()+offset);

  if (dateType == 0) {
    setStartDate(thisdate.getYear()+1900,thisdate.getMonth()+1,thisdate.getDate());
  } else {
    setEndDate(thisdate.getYear()+1900,thisdate.getMonth()+1,thisdate.getDate());
  }


}