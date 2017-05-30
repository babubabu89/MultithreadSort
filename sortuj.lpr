program sortuj;

{==============================================================================}

{$mode objfpc}{$H+}

//{$DEFINE LOWESTPC}
//{$DEFINE LOWPC}
{$DEFINE MIDPC}
//{$DEFINE HIGHPC}
//{$DEFINE HIGHESTPC}
//{$DEFINE SAVE_TO_FILE}

{==============================================================================}

uses
  {$IFDEF UNIX}
  cthreads,
  cmem,
  {$ENDIF}
  Classes, SysUtils, MultiThreadSort, BSort;

{==============================================================================}

const
  {$IFDEF LOWESTPC}
  Zakres : array[0..4] of Cardinal = (2, 4, 8, 16, 32);
  {$ENDIF}
  {$IFDEF LOWPC}
  Zakres : array[0..4] of Cardinal = (80, 160, 320, 640, 1280);
  {$ENDIF}
  {$IFDEF MIDPC}
  Zakres : array[0..4] of Cardinal = (800, 1600, 3200, 6400, 12800);
  {$ENDIF}
  {$IFDEF HIGHPC}
  Zakres : array[0..4] of Cardinal = (8000, 16000, 32000, 64000, 128000);
  {$ENDIF}
  {$IFDEF HIGHESTPC}
  Zakres : array[0..4] of Cardinal = (20000, 40000, 80000, 160000, 320000);
  {$ENDIF}

{==============================================================================}

var
  Start  : Double;
  Stop   : Double;
  Time   : array[0..4] of Double;
  Matrix : array[0..4] of TIntegerArray;
  i, j   : Cardinal;
  {$IFDEF SAVE_TO_FILE}
  DumpFile : Text;
  {$ENDIF}

{==============================================================================}

begin
  Randomize;

  for i := 0 to 4 do
    SetLength(Matrix[i], Zakres[i]);
  {$IFDEF SAVE_TO_FILE}
  AssignFile(DumpFile, 'Info.txt');
  Rewrite(DumpFile);
  {$ENDIF}

  Write('Losowanie tablic...');
  Start := TimeStampToMsecs(DateTimeToTimeStamp(Now));
  for i := 0 to 4 do
  begin
    for j := 0 to Length(Matrix[i]) - 1 do
      Matrix[i,j] := Random(500) - 250;
  end;
  Stop := TimeStampToMsecs(DateTimeToTimeStamp(Now));
  Writeln('Wylosowane. Czas losowania: ', ((Stop - Start) / 1000):4:3, ' sec');
  Writeln;

  {$IFDEF SAVE_TO_FILE}
  Writeln(DumpFile, 'TABLICE NIESORTOWANE:');
  for i := 0 to 4 do
  begin
    Writeln(DumpFile, '  Tablica ' + IntToStr(i) + ': Długość: ' + IntToStr(Length(Matrix[i])));
    for j := 0 to Length(Matrix[i]) - 1 do
      Write(DumpFile, '  ' + IntToStr(Matrix[i,j]) + ' ');
    Writeln(DumpFile);
  end;
  Writeln(DumpFile);
  {$ENDIF}


  Writeln('Sortowanie tablic w jednym watku');
  for i := 0 to 4 do
  begin
    Start := TimeStampToMsecs(DateTimeToTimeStamp(Now));
    BubbleSort(Matrix[i], @V1LargerV2);
    Stop := TimeStampToMsecs(DateTimeToTimeStamp(Now));
    Time[i] := ((Stop - Start) / 1000);
    Writeln('Tablica ', Zakres[i], ' elementow: ', Time[i]:4:3, ' sec');
  end;
  Writeln;

  {$IFDEF SAVE_TO_FILE}
  Writeln(DumpFile, 'TABLICE POSORTOWANE W JEDNYM WĄTKU:');
  for i := 0 to 4 do
  begin
    Writeln(DumpFile, '  Tablica ' + IntToStr(i) + ': Długość: ' + IntToStr(Length(Matrix[i])) + ' Czas sortowania: ' + FloatToStr(Time[i]));
    for j := 0 to Length(Matrix[i]) - 1 do
      Write(DumpFile, '  ' + IntToStr(Matrix[i,j]) + ' ');
    Writeln(DumpFile);
  end;
  Writeln(DumpFile);
  {$ENDIF}

  Write('Losowanie tablic...');
  Start := TimeStampToMsecs(DateTimeToTimeStamp(Now));
  for i := 0 to 4 do
  begin
    for j := 0 to Length(Matrix[i]) - 1 do
    Matrix[i,j] := Random(500) - 250;
  end;
  Stop := TimeStampToMsecs(DateTimeToTimeStamp(Now));
  Writeln('Wylosowane. Czas losowania: ', ((Stop - Start) / 1000):4:3, ' sec');
  Writeln;

  {$IFDEF SAVE_TO_FILE}
  Writeln(DumpFile, 'TABLICE NIESORTOWANE:');
  for i := 0 to 4 do
  begin
    Writeln(DumpFile, '  Tablica ' + IntToStr(i) + ': Długość: ' + IntToStr(Length(Matrix[i])));
    for j := 0 to Length(Matrix[i]) - 1 do
      Write(DumpFile, '  ' + IntToStr(Matrix[i,j]) + ' ');
    Writeln(DumpFile);
  end;
  Writeln(DumpFile);
  {$ENDIF}

  Writeln('Sortowanie tablic w czterech watkach');
  for i := 0 to 4 do
  begin
    Start := TimeStampToMsecs(DateTimeToTimeStamp(Now));
    Sort(Matrix[i], @V1LargerV2);
    Stop := TimeStampToMsecs(DateTimeToTimeStamp(Now));
    Time[i] := ((Stop - Start) / 1000);
    Writeln('Tablica ', Zakres[i], ' elementow: ', Time[i]:4:3, ' sec');
  end;

  {$IFDEF SAVE_TO_FILE}
  Writeln(DumpFile, 'TABLICE POSORTOWANE W CZTERECH WĄTKACH:');
  for i := 0 to 4 do
  begin
    Writeln(DumpFile, '  Tablica ' + IntToStr(i) + ': Długość: ' + IntToStr(Length(Matrix[i])) + ' Czas sortowania: ' + FloatToStr(Time[i]));
    for j := 0 to Length(Matrix[i]) - 1 do
      Write(DumpFile, '  ' + IntToStr(Matrix[i,j]) + ' ');
    Writeln(DumpFile);
  end;
  CloseFile(DumpFile);
  {$ENDIF}
  Writeln;
  Writeln('Zakonczono test');
  Readln;
end.

