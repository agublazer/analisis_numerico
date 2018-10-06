unit bisection;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs;

type
  TBisection = class
    ErrorAllowed: Real;
    Sequence,FunctionList: TstringList;
    FunctionType: Integer;
    AngleType: Integer;
    x: Real;
    A,B: Real;
    function Execute(): Real;
    private
      Error, Angle: Real;
      function f(t: Real): Real;

    public
          function bis(): Real;
          function false_pos(): Real;
      constructor create;
      destructor Destroy; override;

  end;

const
  IsSin = 0;
  IsCos = 1;

  AngleSexagedecimal = 0;
  AngleRadian = 1;

implementation

const
  Top = 100;

constructor TBisection.create;
begin
  Sequence:= TStringList.Create;
  FunctionList:= TStringList.Create;
  FunctionList.AddObject( 'sen', TObject( IsSin ) );
  FunctionList.AddObject( 'cos', TObject( IsCos ) );
  Sequence.Add('');
  Error:= Top;
  x:= 0;

end;

destructor TBisection.Destroy;
begin
  Sequence.Destroy;
  FunctionList.Destroy;
end;

function Power( b: Real; n: Integer ): double;
var i: Integer;
begin
   Result:= 1;
   for i:= 1 to n do
      Result:= Result * b;

end;

function Factorial( n: Integer ): double;
begin

     if n > 1 then
        Result:= n * Factorial( n -1 )

     else if n >= 0 then
        Result:= 1

     else
        Result:= 0;

end;

function TBisection.Execute( ): Real;
begin

   case AngleType of
        AngleRadian: Angle:= x;
        AngleSexagedecimal: Angle:=x * pi/180;
   end;


end;


function TBisection.f(t: Real): Real;
begin
   case FunctionType of
        IsSin: Result:= sin(t);
        IsCos: Result:= cos(t);
   end;
end;

function TBisection.bis(): Real;
var x1,x2,x3: Real;
    acc: integer;
begin
   x1 := A;
   x2 := B;
   acc:= 8;

   if (f(x1)*f(x2) > 0) or (f(x1) = f(x2)) then
      Result:= 0
   else
       begin
         if f(x1)=0 then
            begin
              x2:=x1;
              x3:=x1;
            end;
         if f(x2)=0 then
            begin
              x1:=x2;
              x3:=x2;
            end;
          while abs(f(x1)-f(x2))>1/exp(acc*(ln(10))) do
          begin
            x3:=(x1+x2)/2;
            if f(x3)*f(x2)>=0 then
               x2:=x3;
            if f(x3)*f(x1)>=0 then
               x1:=x3;
          end;
       Result:=x3;
       end;
   end;
function TBisection.false_pos(): Real;
var x1,x2,x3: Real;
    acc: integer;
begin
   x1 := A;
   x2 := B;
   acc:= 8;
   if (f(x1)*f(x2)>0) or (f(x1)=f(x2)) then
      Result:= 0
   else
       begin
       if f(x1)=0 then
          begin
               x2:=x1;
               x3:=x1;
          end;
       if f(x2)=0 then
          begin
               x1:=x2;
               x3:=x2;
          end;
       while (abs(f(x1))>1/exp(acc*(ln(10)))) and (abs(f(x2))>1/exp(acc*(ln(10)))) do
       begin
            x3:=x1-f(x1)*(x2-x1)/(f(x2)-f(x1));
            if f(x3)*f(x2)>=0 then
               x2:=x3;
            if(x3)*f(x1)>=0 then
               x1:=x3;
       end;
       Result:=x3;
       end;
end;
end.


