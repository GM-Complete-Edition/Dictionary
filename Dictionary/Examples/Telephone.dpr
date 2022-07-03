program Telephone;

uses
  Forms,
  Tel in 'Tel.pas' {TelephoneBook};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TTelephoneBook, TelephoneBook);
  Application.Run;
end.
