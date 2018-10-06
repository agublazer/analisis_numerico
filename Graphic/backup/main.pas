unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TAFuncSeries, TASeries,
  TATransformations, TAChartCombos, TAStyles, TAIntervalSources, TATools, Forms,
  Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, ComCtrls, Menus, EditBtn,
  Spin, bisection,parsemath;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btnGraph: TButton;
    btnPoint: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    chartGraphics: TChart;
    chartGraphicsConstantLine1: TConstantLine;
    chartGraphicsConstantLine2: TConstantLine;
    chartGraphicsFuncSeries1: TFuncSeries;
    chartGraphicsLineSeries1: TLineSeries;
    chartGraphicsLineSeries2: TLineSeries;
    chkProportional: TCheckBox;
    cboFunctions: TComboBox;
    ComboBox1: TComboBox;
    ediPointX: TEdit;
    ediPointY: TEdit;
    Edit1: TEdit;
    pnlRight: TPanel;
    trbMax: TTrackBar;
    trbMin: TTrackBar;
    procedure btnGraphClick(Sender: TObject);
    procedure btnPointClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure chartGraphicsFuncSeries1Calculate(const AX: Double; out AY: Double);
    procedure chkProportionalChange(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure trbMaxChange(Sender: TObject);
    procedure trbMinChange(Sender: TObject);
  private
    Bisection: TBisection;
    Parser: TParseMath;
    func: integer;
  public

  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.btnGraphClick(Sender: TObject);
begin
  chartGraphicsFuncSeries1.Active:= False;
  chartGraphicsFuncSeries1.Pen.Color:= clBlue;
  chartGraphicsFuncSeries1.Active:= True;
end;

procedure TfrmMain.btnPointClick(Sender: TObject);
var x, y: Real;
begin
  x:= StrToFloat(ediPointX.Text);
  y:= StrToFloat( ediPointY.Text );
  chartGraphicsLineSeries1.ShowLines:= False;
  chartGraphicsLineSeries1.ShowPoints:= True;
  chartGraphicsLineSeries1.AddXY( x, y );
end;

procedure TfrmMain.Button1Click(Sender: TObject);
var x,a,b: Real;
begin
   Bisection.FunctionType:= Integer( cboFunctions.Items.Objects[ cboFunctions.ItemIndex ] );
   chartGraphicsLineSeries1.Clear();
   chartGraphicsLineSeries1.ShowLines:= False;
   Bisection.A := trbMin.Position;
   Bisection.B := trbMax.Position;

   x:= 0;
   a := Bisection.A;
   repeat
      x:=   Bisection.bis();
      chartGraphicsLineSeries1.AddXY(x, 0);
      Bisection.A := Bisection.A + 0.1;
   until Bisection.A >= Bisection.B;
   Bisection.A:= a;
   repeat
      x:=   Bisection.bis();
      chartGraphicsLineSeries1.AddXY(x, 0);
      Bisection.B := Bisection.B - 0.1;
   until Bisection.B <= Bisection.A;

   chartGraphicsLineSeries1.ShowPoints:= True;

end;

procedure TfrmMain.Button2Click(Sender: TObject);
const
  N = 5000;
  MIN = -500;
  MAX = 500;
var
   Parser2: TParseMath;
   i: Integer;
   x: Double;
begin
   chartGraphicsLineSeries2.Clear();
   Parser2:=TParseMath.create();
   Parser2.AddVariable( 'x', 0 );
   Parser2.Expression := Edit1.Text;
   for i:=0 to N-1 do begin
     x := MIN + (MAX - MIN) * i /(N - 1);
     Parser2.NewValue( 'x', x);
     chartGraphicsLineSeries2.AddXY(x, Parser2.Evaluate());
  end;
  chartGraphicsLineSeries2.SeriesColor:=clBlue;
  chartGraphicsLineSeries2.Active:= False;
  chartGraphicsLineSeries2.Active:= True;

end;


procedure TfrmMain.chartGraphicsFuncSeries1Calculate(const AX: Double; out AY: Double);
begin
  //chartGraphicsFuncSeries1.Active:= False;
  case
  cboFunctions.ItemIndex of
                         0:AY:= sin( AX );
                         1:AY:= cos( AX );
  end;
  //chartGraphicsFuncSeries1.Active:= True;

end;

procedure TfrmMain.chkProportionalChange(Sender: TObject);
begin
  chartGraphics.Proportional:= not chartGraphics.Proportional;
end;

procedure TfrmMain.ComboBox1Change(Sender: TObject);
begin
   case ComboBox1.ItemIndex of  //what entry (which item) has currently been chosen
    0: func:=0;
    1: func:=1;
    2: func:=2;
    3: func:=4;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Bisection:= TBisection.create;
  cboFunctions.Items.Assign( Bisection.FunctionList );
  cboFunctions.ItemIndex:= 0;
  chartGraphics.Extent.UseXMax:= true;
  chartGraphics.Extent.UseXMin:= true;
  ComboBox1.Items.Clear();
  ComboBox1.Items.Add('bisección');
  ComboBox1.Items.Add('falsa pos');
  ComboBox1.Items.Add('newton');
  ComboBox1.Items.Add('secante');
end;

procedure TfrmMain.trbMaxChange(Sender: TObject);
begin
  chartGraphics.Extent.XMax:= trbMax.Position;
end;

procedure TfrmMain.trbMinChange(Sender: TObject);
begin
  chartGraphics.Extent.XMin:= trbMin.Position;
end;

end.

