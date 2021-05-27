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
