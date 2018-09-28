unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TATools, TAChartUtils, TAFuncSeries, TASeries, Forms,
  Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, framefunctions, metodos, ParseMath, Types;

type

  { TfrmGraphics }

  TfrmGraphics = class(TForm)
    Button1: TButton;
    Button2: TButton;
    charFunction: TChart;
    charFunctionConstantLine1: TConstantLine;
    charFunctionConstantLine2: TConstantLine;
    charFunctionFuncSeries1: TFuncSeries;
    charFunctionLineSeries1: TLineSeries;
    ChartToolset1: TChartToolset;
    ChartToolset1DataPointClickTool1: TDataPointClickTool;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    GraphicScroll: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure charFunctionFuncSeries1Calculate(const AX: Double; out AY: Double);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ChartToolset1DataPointClickTool1PointClick(ATool: TChartTool; APoint: TPoint);
  private
    metodo: Methods;
    AuxParser: TParseMath;
    GraphicFrame: Array of TGraphicsFrameTemplate;

  public
    GFMaxPosition,
    GFActualPosition: Integer;
    FinalFunction: string;
    LastFunctionClicked: string;
    Point1: Double;
    procedure AddGraphics;
  end;

var
  frmGraphics: TfrmGraphics;

implementation

{$R *.lfm}

{ TfrmGraphics }

procedure TfrmGraphics.AddGraphics;
begin
   GFMaxPosition:= GFMaxPosition + 1;
   SetLength( GraphicFrame, GFMaxPosition + 1 );
   GraphicFrame[ GFMaxPosition ]:= TGraphicsFrameTemplate.Create( GraphicScroll );
   GraphicFrame[ GFMaxPosition ].Name:= 'GF'+ IntToStr( GFMaxPosition );
   GraphicFrame[ GFMaxPosition ].Parent:= GraphicScroll;
   GraphicFrame[ GFMaxPosition ].Align:= alTop;
   GraphicFrame[ GFMaxPosition ].Tag:= GFMaxPosition;

 (*  with GraphicFrame[ GFMaxPosition -1 ] do
   if GFMaxPosition > 1 then begin
      AnchorSide[akBottom].Side:= asrBottom;
      AnchorSide[akBottom].Control:= GraphicFrame[ GFMaxPosition  ];
      //Anchors:= GraphicFrame[ GFMaxPosition -1 ].Anchors + [akTop];
   end;

   *)
end;

procedure TfrmGraphics.charFunctionFuncSeries1Calculate(const AX: Double; out
  AY: Double);
begin

end;

procedure TfrmGraphics.Button1Click(Sender: TObject);
var func : String;
    result : double;
begin
  metodo.MethodType:= Integer( ComboBox1.Items.Objects[ ComboBox1.ItemIndex ] );
  func:= Edit1.Text;
  metodo.h := StrToFloat(Edit4.Text);
  metodo.ErrorAllowed:= StrToFloat( Edit5.Text );
  metodo.func1:=func;
  metodo.func2:=Edit7.Text;
  result:= metodo.execute();
  Edit6.Text := FloatToStr(result);
  AuxParser := TParseMath.create();
  AuxParser.AddVariable('x', 0);
  AuxParser.Expression:= LastFunctionClicked;
  AuxParser.NewValue('x', result);
  charFunctionLineSeries1.AddXY(result,AuxParser.evaluate());
  charFunctionLineSeries1.ShowPoints:= True;
end;

procedure TfrmGraphics.Button2Click(Sender: TObject);
begin
  FinalFunction:= '';
  LastFunctionClicked:= '';
  Edit1.Text:= FinalFunction;
  Edit2.Text:= FinalFunction;
  Edit3.Text:= FinalFunction;
  //Edit4.Text:= FinalFunction;
 // Edit5.Text:= FinalFunction;
  Edit6.Text:= FinalFunction;
end;

procedure TfrmGraphics.FormCreate(Sender: TObject);
begin
  metodo:= Methods.create;
  ComboBox1.Items.Assign(metodo.MethodList);
  ComboBox1.ItemIndex:= 0;
  GFMaxPosition:= -1;
  FinalFunction:= '';
  AddGraphics;

end;

procedure TfrmGraphics.FormDestroy(Sender: TObject);
var i: Integer;
begin
  for i:= 0 to Length( GraphicFrame ) - 1 do
      if Assigned( GraphicFrame[ i ] ) then
         GraphicFrame[ i ].Destroy;

end;
procedure TfrmGraphics.ChartToolset1DataPointClickTool1PointClick(
  ATool: TChartTool; APoint: TPoint);
var Expression: string;
  Pg: TDoublePoint;
  i: Integer;
begin
  Pg:= charFunction.ImageToGraph(APoint);
  with ATool as TDataPointClickTool do
      if Series is TFuncSeries then begin
         AuxParser := TParseMath.create();
         AuxParser.AddVariable('x', 0);
         for i := 0 to GFMaxPosition - 1 do begin
             AuxParser.Expression := GraphicFrame[i].ediF.Text;
             AuxParser.NewValue('x', Pg.X);

             if ( abs(AuxParser.Evaluate() - PG.y) <= 0.1) then
             begin
                 Expression:= GraphicFrame[i].ediF.Text;
                 LastFunctionClicked:= Expression;
                 if FinalFunction = '' then
                      begin
                      FinalFunction:= Expression;
                      Point1:= pg.X;
                      end
                 else
                     begin
                     FinalFunction:= FinalFunction + ' - (' + Expression + ')';
                     Point1:= (Point1 + pg.X)/2;
                     end;
                 Edit2.Text:= FloatToStr(Point1);
                 AuxParser.destroy;
                 break;
             end;

         end;end;ShowMessage(FinalFunction); Edit1.Text:= FinalFunction; end;
end.

