unit class_taylor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs;

type
  TTaylor = class
    ErrorAllowed: Real;
    Sequence,
    FunctionList: TstringList;
    FunctionType: Integer;
    AngleType: Integer;
    x: Real;
    function Execute(): Real;
    private
      Error,
      Angle: Real;
      function sen(): Real;
      function cos(): Real;
    public

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
  Top = 100000;

constructor TTaylor.create;
begin
  Sequence:= TStringList.Create;
  FunctionList:= TStringList.Create;
  FunctionList.AddObject( 'sen', TObject( IsSin ) );
  FunctionList.AddObject( 'cos', TObject( IsCos ) );
  Sequence.Add('');
  Error:= Top;
  x:= 0;

end;

destructor TTaylor.Destroy;
begin
  Sequence.Destroy;
  FunctionList.Destroy;
end;

function Power( b: Real; n: Integer ): Real;
var i: Integer;
begin
   Result:= 1;
   for i:= 1 to n do
      Result:= Result * b;

end;

function Factorial( n: Integer ): Integer;
begin

     if n > 1 then
        Result:= n * Factorial( n -1 )

     else if n >= 0 then
        Result:= 1

     else
        Result:= 0;

end;

function TTaylor.Execute( ): Real;
begin

   case AngleType of
        AngleRadian: Angle:= x;
        AngleSexagedecimal: Angle:=x * pi/180;
   end;

   case FunctionType of
        IsSin: Result:= sen();
        IsCos: Result:= cos();
   end;


end;

function TTaylor.sen(): Real;
var xn: Real;
     n: Integer;
begin
   Result:= 0;
   n:= 0;

   repeat
     xn:= Result;

     Result:= Result + Power(-1, n)/Factorial( 2*n + 1 ) * Power(Angle, 2*n + 1);
     if n > 0 then
        Error:= abs( Result - xn );

     Sequence.Add( FloatToStr( Result ) );
     n:= n + 1;

   until ( Error <= ErrorAllowed ) or ( n >= Top ) ;

end;


function TTaylor.cos(): Real;
var xn: real;
    n: Integer;

begin
  Result:= 0;
  n:= 0;

  repeat
    xn:= Result;
    Result:= Result + Power( -1, n)/Factorial(2*n) * Power( Angle, 2*n );
    Sequence.Add( FloatToStr( Result ) );
    if n > 0 then
       Error:= abs( Result - xn );

    n:= n + 1;
  until ( Error < ErrorAllowed ) or ( n >= Top );

end;

end.

