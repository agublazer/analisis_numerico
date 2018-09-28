unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, ParseMath, LCLType, StdCtrls, ComCtrls,   TASeries,
  TAFuncSeries;

type

  { TForm1 }

  TForm1 = class(TForm)
    Chart1: TChart;
    colorbtnFunction: TColorButton;
    ediStep: TEdit;
    ediMin: TEdit;
    ediMax: TEdit;
    Panel1: TPanel;
    ScrollBox1: TScrollBox;
    TrackBar1: TTrackBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FunctionsEditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FunctionSeriesCalculate(const AX: Double; out AY: Double);

  private
    FunctionList,
    EditList: TList;
    ActiveFunction: Integer;
    min,
    max: Real;
    Parse  : TparseMath;
    function f( x: Real ): Real;
    procedure CreateNewFunction;
    procedure Graphic2D;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

const
  FunctionEditName = 'FunctionEdit';
  FunctionSeriesName = 'FunctionLines';

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  FunctionList:= TList.Create;
  EditList:= TList.Create;
  min:= -5.0;
  max:= 5.0;
  Parse:= TParseMath.create();
  Parse.AddVariable('x', min);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
    Parse.destroy;
  FunctionList.Destroy;
  EditList.Destroy;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
    CreateNewFunction;
end;


function TForm1.f( x: Real ): Real;
begin
  //func:= TEdit( EditList[ ActiveFunction ] ).Text;
  Parse.Expression:= TEdit( EditList[ ActiveFunction ] ).Text;
  Parse.NewValue('x', x);
  Result:= Parse.Evaluate();

end;

procedure TForm1.FunctionsEditKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if not (key = VK_RETURN) then
     exit;

    if trim( TEdit( Sender ).Text) = EmptyStr  then
       exit;

   with TEdit( Sender ) do begin
       ActiveFunction:= Tag;
       Graphic2D;
       if tag = EditList.Count - 1 then
          CreateNewFunction;
   end;
end;

procedure TForm1.FunctionSeriesCalculate(const AX: Double; out AY: Double);
begin

end;



procedure TForm1.CreateNewFunction;
begin
   EditList.Add( TEdit.Create(ScrollBox1) );

   //We create Edits with functions
   with Tedit( EditList.Items[ EditList.Count - 1 ] ) do begin
        Parent:= ScrollBox1;
        Align:= alTop;
        name:= FunctionEditName + IntToStr( EditList.Count );
        OnKeyUp:= @FunctionsEditKeyUp;
        Font.Size:= 15;
        Text:= EmptyStr;
        Tag:= EditList.Count - 1;
        SetFocus;

   end;

   //We create serial functions
   FunctionList.Add( TLineSeries.Create( Chart1 ) );
   with TLineSeries( FunctionList[ FunctionList.Count - 1 ] ) do begin
        Name:= FunctionSeriesName + IntToStr( FunctionList.Count );
        Tag:= EditList.Count - 1; // Edit Asossiated

   end;


   Chart1.AddSeries( TLineSeries( FunctionList[ FunctionList.Count - 1 ] ) );

end;


procedure TForm1.Graphic2D;
var x, h: Real;

begin
  h:= StrToFloat( ediStep.Text );
  min:= StrToFloat( ediMin.Text );
  max:= StrToFloat( ediMax.Text );

  with TLineSeries( FunctionList[ ActiveFunction ] ) do begin
       LinePen.Color:= colorbtnFunction.ButtonColor;
       LinePen.Width:= TrackBar1.Position;

  end;

  x:= min;
  TLineSeries( FunctionList[ ActiveFunction ] ).Clear;
  with TLineSeries( FunctionList[ ActiveFunction ] ) do
  repeat
      AddXY( x, f(x) );
      x:= x + h
  until ( x>= max );

end;


end.

