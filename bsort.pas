unit BSort;

{==============================================================================}

{$mode objfpc}{$H+}

{==============================================================================}

interface

{==============================================================================}

uses
  Classes, SysUtils;

{==============================================================================}

type
  TcompFunc = function(AValue1, AValue2 : Integer) : boolean;
  TIntegerArray = array of integer;
  PIntegerArray = ^TIntegerArray;

{==============================================================================}

procedure BubbleSort(var AMatrix : TIntegerArray; ACompFunc : TCompFunc);
function V1LargerV2(AValue1, AValue2 : Integer) : Boolean;

{==============================================================================}

implementation

{==============================================================================}

procedure Swap(var AValue1, AValue2 : Integer);
var
  Tmp : Integer;
begin
  Tmp := AValue1;
  AValue1 := AValue2;
  AValue2 := Tmp;
end;

{==============================================================================}

function V1LargerV2(AValue1, AValue2 : Integer) : Boolean;
begin
  result := AValue1 > AValue2;
end;

{------------------------------------------------------------------------------}

procedure BubbleSort(var AMatrix : TIntegerArray; ACompFunc : TCompFunc);
var
  i,j : Cardinal;
begin
  for i := Low(AMatrix) to High(AMatrix) - 1 do
    for j := Low(AMatrix) to High(AMatrix) - 1 do
    begin
      if ACompFunc(AMatrix[j], AMatrix[j+1]) then
        Swap(AMatrix[j], AMatrix[j+1]);
    end;
end;

{==============================================================================}

end.

