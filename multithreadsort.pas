unit MultiThreadSort;

{==============================================================================}

{$mode objfpc}{$H+}

{==============================================================================}

interface

{==============================================================================}

uses
  Classes, SysUtils, BSort;

{==============================================================================}

type
  TSortThread = class(TThread)
      FMatrix   : PIntegerArray;
      FCompFunc : TCompFunc;
    protected
      procedure Execute; override;
    public
      constructor Create(var AMatrix : TIntegerArray; ACompFunc : TCompFunc);
    public
      property Terminated;
  end;

{==============================================================================}

procedure Sort(var AMatrix : TIntegerArray; ACompFunc : TCompFunc);

{==============================================================================}

implementation

{==============================================================================}

constructor TSortThread.Create(var AMatrix : TIntegerArray; ACompFunc : TCompFunc);
begin
  inherited Create(False);
  FreeOnTerminate := False;
  FMatrix := @AMatrix;
  FCompFunc := ACompFunc;
end;

{------------------------------------------------------------------------------}

procedure TSortThread.Execute;
begin
  BubbleSort(FMatrix^, FCompFunc);
end;

{==============================================================================}

procedure Sort(var AMatrix : TIntegerArray; ACompFunc : TCompFunc);
var
  SortThread  : array[0..3] of TSortThread;
  Matrix      : array[0..3] of TIntegerArray;
  Lowest,
  Highest     : Integer;
  Limit       : array[0..2] of Integer;
  i, k, l     : Cardinal;
  j           : array[0..3] of Cardinal;
  EmptyMatrix : Boolean;
begin
  // Znalezienie największej i najmniejszej liczby w tablicy.
  Lowest := High(Integer);
  Highest := Low(Integer);
  for i := Low(AMatrix) to High(AMatrix) do
  begin
    if AMatrix[i] > Highest then
      Highest := AMatrix[i];
    if AMatrix[i] < Lowest then
      Lowest := AMatrix[i];
  end;

  // Zerowanie tablic pomocniczych.
  for i := 0 to 3 do
    SetLength(Matrix[i], 0);

  // Wyznaczanie granic
  Limit[1] := (Lowest + Highest) div 2;
  Limit[0] := (Lowest + Limit[1]) div 2;
  Limit[2] := (Limit[1] + Highest) div 2;

  // Podział tablicy do sortowania na cztery tablice:
  // - pierwsza od najmniejszej liczby do pierwszej granicy.
  // - druga od pierwszej granicy do drugiej granicy.
  // - trzecia od drugiej granicy do trzeciej granicy.
  // - czwarta od trzeciej granicy do największej liczby.
  for i := 0 to 3 do
    j[i] := 0;
  for i := Low(AMatrix) to High(AMatrix) do
    if AMatrix[i] < Limit[0] then
    begin
      SetLength(Matrix[0], Length(Matrix[0]) + 1);
      Matrix[0,j[0]] := AMatrix[i];
      Inc(j[0]);
    end
    else if (AMatrix[i] >= Limit[0]) and (AMatrix[i] < Limit[1]) then
    begin
      SetLength(Matrix[1], Length(Matrix[1]) + 1);
      Matrix[1,j[1]] := AMatrix[i];
      Inc(j[1]);
    end
    else if (AMatrix[i] >= Limit[1]) and (AMatrix[i] < Limit[2]) then
    begin
      SetLength(Matrix[2], Length(Matrix[2]) + 1);
      Matrix[2,j[2]] := AMatrix[i];
      Inc(j[2]);
    end
    else if (AMatrix[i] >= Limit[2]) then
    begin
      SetLength(Matrix[3], Length(Matrix[3]) + 1);
      Matrix[3,j[3]] := AMatrix[i];
      Inc(j[3]);
    end;

  // Sprawdzenie czy tablice pomocnicze mają co najmnej dwa elementy.
  EmptyMatrix := false;
  for i := 0 to 3 do
  begin
    if Length(Matrix[i]) < 2 then
      EmptyMatrix := true;
  end;

  if EmptyMatrix then
  begin
    BubbleSort(AMatrix, ACompFunc);
  end
  else
  begin
    //Tworzenie i start wątków sortujacych.
    for i := 0 to 3 do
      SortThread[i] := TSortThread.Create(Matrix[i], ACompFunc);

    // Oczekiwanie na zakończenie wątków sortujących.
    for i := 0 to 3 do
      SortThread[i].WaitFor;

    // Zwalnianie wątków sortujacych.
    for i := 0 to 3 do
      FreeAndNil(SortThread[i]);

    // Łączenie tablic pomocniczych w jedną.
    k := 0;
    for i := 0 to 3 do
      for l := Low(Matrix[i]) to High(Matrix[i]) do
      begin
        AMatrix[k] := Matrix[i,l];
        Inc(k);
      end;
  end;
end;

{==============================================================================}

end.
