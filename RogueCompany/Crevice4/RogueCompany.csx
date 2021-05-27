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

RogueCompany.
On(Keys.XButton1).
On(Keys.WheelUp).
Do(ctx => {
    SendInput.KeyDown(Keys.D5);
    SendInput.KeyUp(Keys.D5);
});

RogueCompany.
On(Keys.XButton1).
On(Keys.WheelDown).
Do(ctx => {
    SendInput.KeyDown(Keys.D5);
    SendInput.KeyUp(Keys.D5);
});
