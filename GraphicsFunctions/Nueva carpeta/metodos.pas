unit metodos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ParseMath;

type
  Methods = class
    ErrorAllowed : Real;
    MainParser: TParseMath;
    func1, func2: string;
    a,b,h: Real;
    function execute(): Double;
    function f(x: Real): Double;
    function derivative(x: Real): Double;
    function deriv(x: Real): Double;
    private
      Error: Real;
      function newton_raphson(): Double;
      function secant_line(): Double;
    public

    MethodList: TStringList;
    MethodType: Integer;
      constructor create;
      destructor Destroy; override;

  end;
const
  nr = 0;
  sec = 1;

implementation
const
  Top = 10000;

constructor Methods.create;
begin
    MethodList:= TStringList.Create;
    MethodList.AddObject( 'newton - rapshon', TObject( nr ) );
    MethodList.AddObject( 'recta secante', TObject( sec ) );
    Error:= Top;
    MainParser := TParseMath.create();
    MainParser.AddVariable( 'x', 0);
    MainParser.Expression:= 'x';
end;
destructor Methods.Destroy;
begin
  MethodList.Destroy;
end;

function Power( base: Real; e: Integer ): double;
var i: Integer;
begin
   Result:= 1;
   for i:= 1 to e do
      Result:= Result * base;
end;

function Factorial( n: Integer ): double;
begin

     if n > 1 then
        Result:= n * Factorial( n - 1 )

     else if n >= 0 then
        Result:= 1

     else
        Result:= 0;

end;

function Methods.execute(): Double;
begin
  case MethodType of
  nr : Result:= newton_raphson();
  sec : Result:= secant_line();
  end;
end;

function Methods.f(x: Real): Double;
begin
  MainParser.Expression := func1;
  MainParser.NewValue('x', x);
  Result := MainParser.Evaluate();
end;

function Methods.derivative(x: Real) : Double;
begin
  MainParser.Expression := func2;
  MainParser.NewValue('x', x);
  Result := MainParser.Evaluate();
end;

function Methods.deriv(x: Real): Double;
begin
    Result:= (f(x+h) - f(x-h))/(2*h);
end;

function Methods.newton_raphson(): Double;
var xn: Real;
    n: Integer;
begin
  Result:= a;
  n:= 0;
  repeat
    xn:= Result;
    Result:= xn - (f(xn)/derivative(xn));
    if n > 0 then
       Error:= abs( Result - xn );

    n:= n + 1;
  until ( Error < ErrorAllowed ) or ( n >= Top );
end;

function Methods.secant_line(): Double;
var xn: Real;
    n: Integer;
begin
  Result:= a;
  n:= 0;
  repeat
    xn:= Result;
    Result:= xn - ((2*h*f(xn))/(f(xn + h) - f(xn - h)));
    if n > 0 then
       Error:= abs( Result - xn );

    n:= n + 1;
  until ( Error < ErrorAllowed ) or ( n >= Top );
end;

end.

