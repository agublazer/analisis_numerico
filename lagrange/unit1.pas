unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, Forms, Controls,
  Graphics, Dialogs, StdCtrls, Grids, ComCtrls,parsemath;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Chart1: TChart;
    Chart1ConstantLine1: TConstantLine;
    Chart1ConstantLine2: TConstantLine;
    Chart1FuncSeries1: TFuncSeries;
    Chart1FuncSeries2: TFuncSeries;
    Chart1LineSeries1: TLineSeries;
    Chart1LineSeries2: TLineSeries;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    RadioButton1: TRadioButton;
    StringGrid1: TStringGrid;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    procedure Chart1FuncSeries1Calculate(const x: Double; out AY: Double);
    procedure Chart1FuncSeries2Calculate(const x: Double; out AY: Double);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }



procedure TForm1.Edit1Change(Sender: TObject);
begin
  if (Edit1.Text = '') then
     StringGrid1.ColCount := 0
  else
      begin
      StringGrid1.ColCount:=StrToInt(Edit1.Text);
      end;
end;

procedure TForm1.Edit2Change(Sender: TObject);
begin
  if (Edit2.Text = '') then
      begin
      StringGrid1.RowCount := 0;
      end
  else
     begin
          StringGrid1.RowCount:=StrToInt(Edit2.Text);
     end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Chart1.Extent.UseXMax:= true;
  Chart1.Extent.UseXMin:= true;
end;

procedure TForm1.RadioButton1Change(Sender: TObject);
begin
  Chart1.Proportional:= not Chart1.Proportional;
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  Chart1.Extent.XMax:= TrackBar1.Position;
end;

procedure TForm1.TrackBar2Change(Sender: TObject);
begin
   Chart1.Extent.XMin:= TrackBar2.Position;
end;

procedure TForm1.Button1Click(Sender: TObject);
var i,j,a,b: integer;
    xo,xj, divi: real;
begin
  a:= StringGrid1.ColCount - 1;
  b:= StringGrid1.RowCount - 1;
  Edit3.Text:=Edit3.Text+StringGrid1.Cells[0,1];
  divi:= 1;
  for j:= 0 to a do
       begin
            if (j<> 0) then
            begin
            divi:= divi*((StrToFloat(StringGrid1.Cells[0,0])- StrToFloat(StringGrid1.Cells[j,0])));
            Edit3.Text:= Edit3.Text + '*( x ' + '-(' + StringGrid1.Cells[j,0]+'))';
            end;
       end;
  Edit3.Text:=Edit3.Text+'/('+ FloatToStr(divi) +')';
  divi:= 1;
  for i:= 1 to a do
  begin
  divi:= 1;
  Edit3.Text:= Edit3.Text + '+' + StringGrid1.Cells[i,1] ;
       for j:= 0 to a do
       begin
            if (j<> i) then
            begin
            divi:= divi*((StrToFloat(StringGrid1.Cells[i,0])- StrToFloat(StringGrid1.Cells[j,0])));
            Edit3.Text:= Edit3.Text + '*( x ' + '-(' + StringGrid1.Cells[j,0]+'))';
            end;
       end;
       Edit3.Text:=Edit3.Text+'/('+ FloatToStr(divi) +')';
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
const
  N = 5000;
  MIN = -500;
  MAX = 500;
var
   Parser2: TParseMath;
  i: Integer;
  x: Double;
begin
  Chart1LineSeries1.Clear();
  Parser2:=TParseMath.create();
  Parser2.AddVariable( 'x', 0 );
  Parser2.Expression := Edit3.Text;
  for i:=0 to N-1 do begin
    x := MIN + (MAX - MIN) * i /(N - 1);
    Parser2.NewValue( 'x', x);
    Chart1LineSeries1.AddXY(x, Parser2.Evaluate());
  end;
  Chart1LineSeries1.Active:= False;
  Chart1LineSeries1.Active:= True;

end;

procedure TForm1.Chart1FuncSeries1Calculate(const x: Double; out AY: Double);
begin
  //AY:= 2*x/3 + 2;
  AY:= sin(x);
end;
procedure TForm1.Chart1FuncSeries2Calculate(const x: Double; out AY: Double);
begin
  //AY:= 2*x/3 + 2;
  AY:= cos(x);
end;

end.

