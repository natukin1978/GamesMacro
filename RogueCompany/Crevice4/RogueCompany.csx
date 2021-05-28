/*
   How to use
   
   1. Place RogueCompany.csx in the UserScript directory of Crevice4.

   2. Open the file default.csx.

   3. Find the following section
      #region #load directive section.

   4. Add the following to that section.
      #load "RogueCompany.csx"
*/

var RogueCompany = When(ctx =>
{
    return ctx.ForegroundWindow.ModuleName == "RogueCompany.exe";
});

var RogueCompanyShift = RogueCompany.On(Keys.XButton1);

RogueCompanyShift.
On(Keys.WheelUp).
Do(ctx => {
    var key = Keys.D5;
    SendInput.KeyDown(key);
    SendInput.KeyUp(key);
});

RogueCompanyShift.
On(Keys.WheelDown).
Do(ctx => {
    var key = Keys.D5;
    SendInput.KeyDown(key);
    SendInput.KeyUp(key);
});
