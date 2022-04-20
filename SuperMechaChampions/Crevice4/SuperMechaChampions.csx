/*
   How to use

   1. Place SuperMechaChampions.csx in the UserScript directory of Crevice4.

   2. Open the file default.csx.

   3. Find the following section
      #region #load directive section.

   4. Add the following to that section.
      #load "SuperMechaChampions.csx"
*/

var SuperMechaChampions = When(ctx =>
{
    return ctx.ForegroundWindow.ModulePath.Contains("Super Mecha Champions");
});

var SuperMechaChampionsShift = SuperMechaChampions.On(Keys.XButton1);

SuperMechaChampionsShift.
On(Keys.WheelUp).
Do(ctx => {
    var key = Keys.D1;
    SendInput.KeyDown(key);
    SendInput.KeyUp(key);
});

SuperMechaChampionsShift.
On(Keys.WheelDown).
Do(ctx => {
    var key = Keys.D2;
    SendInput.KeyDown(key);
    SendInput.KeyUp(key);
});
