function search ($searchKey) {
  $target = "E:\git\md-set"
  cd $target
  $script:count = 0

function searchDirectory ($searchKey) {
  $files = get-childItem *.md && Get-ChildItem -Directory
  for ($i = 0; $i -lt $files.Count; $i++) {
    if(Test-Path $files[$i] -PathType Container) {
      Set-Location $files[$i]
      return searchDirectory($searchKey)
    } else {
      $current = $files[$i]
      $targetContext = Get-Content $current | Select-String -Pattern $searchKey -CaseSensitive -SimpleMatch
      if($targetContext.Length) {
        Write-Host $targetContext
        Write-Host "内容位于: $current"
        $script:count++
      }
    }
  }
}

Measure-Command -Expression {
  searchDirectory($searchKey)
} | Select-Object -Property TotalMilliseconds

  cd $target
  Write-Host "有 $count 个结果"
}