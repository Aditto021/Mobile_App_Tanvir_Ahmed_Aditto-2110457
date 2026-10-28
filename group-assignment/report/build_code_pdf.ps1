# Builds a PDF with every Dart file of the Group Assignment (cover page + code listing).
param([string]$PdfPath = "D:\IUB files\CSE-464_Group_Assignment_2110457.pdf")

$root = "D:\IUB files\Mobile App\project-1-forms"
$reportDir = "$root\report"
Copy-Item "D:\IUB files\Mobile App\flutter-qa-answers\report\iub_logo.png" "$reportDir\iub_logo.png" -Force

# Files in reading order
$files = @(
  'lib/main.dart',
  'lib/screens/registration_form_page.dart',
  'lib/screens/form_wizard_page.dart',
  'lib/utils/validators.dart',
  'lib/utils/countries.dart',
  'lib/utils/date_helper.dart',
  'lib/utils/draft_storage.dart',
  'lib/widgets/simple_input_widget.dart',
  'lib/widgets/password_input_widget.dart',
  'lib/widgets/birth_date_field.dart',
  'lib/widgets/country_search_field.dart',
  'lib/widgets/gender_radio_field.dart',
  'lib/widgets/section_title.dart'
)

function Escape([string]$s) { [System.Net.WebUtility]::HtmlEncode($s) }

$toc = ($files | ForEach-Object -Begin { $i = 0 } -Process {
  $i++
  $lines = (Get-Content "$root\$_" -Encoding UTF8).Count
  "<tr><td>$i</td><td>$_</td><td>$lines</td></tr>"
}) -join "`n"

$sections = ($files | ForEach-Object -Begin { $i = 0 } -Process {
  $i++
  $code = Escape ([System.IO.File]::ReadAllText("$root\$_", [System.Text.Encoding]::UTF8))
  "<div class=`"codefile`">$i. $_</div>`n<pre>$code</pre>"
}) -join "`n"

$html = @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>CSE-464 Group Assignment - 2110457</title>
<style>
  @page { size: A4; margin: 16mm 14mm 18mm 14mm;
    @bottom-center { content: "Page " counter(page) " of " counter(pages); font: 9pt "Segoe UI", Arial, sans-serif; color: #000; }
    @bottom-right { content: "Tanvir Ahmed Aditto - 2110457"; font: 9pt "Segoe UI", Arial, sans-serif; color: #000; } }
  @page :first { @bottom-center { content: none; } @bottom-right { content: none; } }
  body { font-family: "Segoe UI", Arial, sans-serif; font-size: 10.5pt; line-height: 1.5; color: #000; }
  .cover { height: 258mm; display: flex; flex-direction: column; align-items: center; text-align: center; page-break-after: always; }
  .cover .main { flex: 1; display: flex; flex-direction: column; justify-content: flex-start; padding-top: 14mm; }
  .cover .uni { font-size: 15pt; letter-spacing: 1px; font-weight: 600; }
  .cover .school { font-size: 11pt; margin-top: 4px; }
  .cover h1 { font-size: 26pt; margin: 36px 0 2px; letter-spacing: 1px; }
  .cover h3 { font-size: 14pt; margin: 4px 0 6px; font-weight: 600; }
  .cover .line { width: 60mm; border-top: 2px solid #000; margin: 6px auto 36px; }
  .cover table { margin: 0 auto; border-collapse: collapse; font-size: 12pt; text-align: left; }
  .cover td { padding: 7px 18px; border-bottom: 1px solid #000; }
  .cover td:first-child { font-weight: 600; }
  .cover .logo { width: 55mm; margin-top: 6mm; }
  .toc { page-break-after: always; }
  .toc table { width: 100%; border-collapse: collapse; }
  .toc td, .toc th { border: 1px solid #000; padding: 3px 8px; font-size: 10pt; text-align: left; }
  .tree { font-family: Consolas, monospace; font-size: 9.5pt; border: 1px solid #000; padding: 8px 12px; white-space: pre; }
  .codefile { font-family: Consolas, monospace; font-size: 9pt; font-weight: bold; color: #fff; background: #000; padding: 3px 10px; margin-top: 14px; break-after: avoid; }
  pre { font-family: Consolas, "Courier New", monospace; font-size: 8.3pt; line-height: 1.3; color: #000; border: 1px solid #000; border-top: none; padding: 8px 10px; margin: 0 0 8px; white-space: pre-wrap; word-break: break-word; }
</style>
</head>
<body>
<div class="cover">
  <img class="logo" src="iub_logo.png" alt="IUB logo">
  <div class="main">
    <div class="uni">INDEPENDENT UNIVERSITY, BANGLADESH</div>
    <div class="school">School of Engineering, Technology &amp; Sciences</div>
    <h1>GROUP ASSIGNMENT</h1>
    <h3>Forms with Validation - Source Code</h3>
    <div class="line"></div>
    <table>
      <tr><td>Course Name</td><td>Mobile App Development</td></tr>
      <tr><td>Course ID</td><td>CSE 464</td></tr>
      <tr><td>Student Name</td><td>Tanvir Ahmed Aditto</td></tr>
      <tr><td>Student ID</td><td>2110457</td></tr>
      <tr><td>Group</td><td>G-10</td></tr>
      <tr><td>Email</td><td>2110457@iub.edu.bd</td></tr>
      <tr><td>GitHub</td><td>github.com/Aditto021</td></tr>
    </table>
  </div>
</div>
<div class="toc">
  <h2>Contents</h2>
  <table>
    <tr><th style="width:8%">#</th><th>File</th><th style="width:14%">Lines</th></tr>
$toc
  </table>
  <h3>Folder structure</h3>
<div class="tree">lib/
|-- main.dart
|-- screens/
|   |-- registration_form_page.dart   (Part 1: User Registration Form)
|   +-- form_wizard_page.dart         (Part 2: Multi-Step Form Wizard)
|-- utils/
|   |-- validators.dart
|   |-- countries.dart
|   |-- date_helper.dart
|   +-- draft_storage.dart
+-- widgets/
    |-- simple_input_widget.dart
    |-- password_input_widget.dart
    |-- birth_date_field.dart
    |-- country_search_field.dart
    |-- gender_radio_field.dart
    +-- section_title.dart</div>
  <p>Built with Flutter and Dart only (no extra packages). Run with <code>flutter pub get</code> then <code>flutter run -d chrome</code>.</p>
</div>
$sections
</body>
</html>
"@

$htmlPath = "$reportDir\code.html"
[System.IO.File]::WriteAllText($htmlPath, $html, (New-Object System.Text.UTF8Encoding $false))

$chrome = "C:\Program Files\Google\Chrome\Application\chrome.exe"
$ud = "D:\Softwares\FlutterDev\chrome-temp"
$url = "file:///" + ($htmlPath -replace '\\', '/')
& $chrome --headless=new --disable-gpu --user-data-dir="$ud" --no-pdf-header-footer --virtual-time-budget=10000 --print-to-pdf="$PdfPath" $url 2>$null | Out-Null
Get-Item $PdfPath | Select-Object FullName, Length
