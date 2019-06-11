function Remove-Diacritic
{
	[CmdletBinding()]
	PARAM
	(
		[ValidateNotNullOrEmpty()]
		[String] $String,
		[Text.NormalizationForm] $NormalizationForm = "FormD"
	)

    try
    {	
        # Normalize - https://docs.microsoft.com/en-us/dotnet/api/system.text.normalizationform?view=netframework-4.8
        $NormalizedStr = $String.Normalize($NormalizationForm)
        $NewStr = New-Object -TypeName System.Text.StringBuilder

        $normalizedStr.ToCharArray() |
        ForEach-Object -Process {
            if ([Globalization.CharUnicodeInfo]::GetUnicodeCategory($_) -ne [Globalization.UnicodeCategory]::NonSpacingMark)
            {
                [void]$NewStr.Append($_)
            }
        }

        Write-Output $($NewStr -as [string])
    }
    Catch
    {
        Write-Error -Message $Error[0].Exception.Message
    }
}
