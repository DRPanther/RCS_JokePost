program jokepost;

{$mode objfpc}{$H+}

uses SysUtils, strutils, crt;
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  //Classes
  { you can add units after this }

Const
  prog    = 'RCS Joke Post';
  ver     = '1.0.2.2';
  red     = (#27'[1;31m');
  green   = (#27'[1;32m');
  yellow  = (#27'[1;33m');
  blue    = (#27'[1;34m');
  magenta = (#27'[1;35m');
  cyan    = (#27'[1;36m');
  nocolor = (#27'[0m');

Var
  qnum    : longint;
  qnum1   : string;
  count   : integer;
  joke    : textfile;
  jokes   : textfile;
  jokedupe: textfile;
  str1    : string;
  str2    : string;
  ran     : LongInt;

Procedure rnum;
begin

  Randomize;
  qnum:=(Random(ran)+1);

end;

Procedure dupecheck;
begin

  if fileexists('jokedupe.log')=true then begin
    reset(jokedupe);
    while not eof(jokedupe) do
      begin
        readln(jokedupe,str1);
        if str1<>'' then begin
        if qnum=(strtoint(str1)) then
          begin
            if (count=(ran*250)) then begin
              writeln('All available jokes have been posted! ');
              halt;
            end;
            inc(count);
            Delay(1000);
            rnum;
            dupecheck;
          end;
        end;
      end;
  end;
end;

Procedure header;
begin

  writeln(joke);
  writeln(joke,blue+'***********************************');
  writeln(joke);

end;

Procedure footer;
begin

  header;
  write(joke,cyan);
  writeln(joke,prog+' '+ver);
  write(joke,blue);
  write(joke,'(c)');
  write(joke,cyan);
  write(joke,'2018-2019');
  writeln(joke,nocolor);
  writeln(joke);
  writeln(joke);
  writeln(joke,nocolor+'---');

end;

Procedure quit;
begin
  writeln('Program completed');
end;

Procedure GetMaxEntry;
begin

  while not eof(jokes) do
    begin
      readln(jokes,str2);
    end;
  ran:=strtoint(Copy(str2,1,3));
  ran:=ran-1;
  closefile(jokes);
end;

{$R *.res}

begin
  qnum:=0;
  qnum1:='*';
  count:=0;
  assignfile(jokes,'jokes.txt');
  assignfile(joke,'jokes.rpt');
  assignfile(jokedupe,'jokedupe.log');
  reset(jokes);
  GetMaxEntry;
  rewrite(joke);
  reset(jokes);

  rnum;
  dupecheck;

  if fileexists('jokedupe.log')=false then Rewrite(jokedupe)
    else append(jokedupe);

  writeln(jokedupe);
  write(jokedupe,qnum);
  header;

  while not eof(jokes) do
    begin
      readln(jokes,str1);
      if AnsiStartsStr((inttostr(qnum)),str1) then begin
        repeat
        readln(jokes,str1);
        if AnsiStartsStr(qnum1,str1) then break;
        write(joke,red);
        writeln(joke,str1);
        write(joke,nocolor);
        until AnsiStartsStr(qnum1,str1);
        break;
      end;
    end;

  footer;

  closefile(jokes);
  closefile(joke);
  closefile(jokedupe);
  quit;
end.

