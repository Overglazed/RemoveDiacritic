function Remove-Diacritic
{
	[CmdletBinding()]
	param
	(
		[ValidateNotNullOrEmpty()]
        [String] $String,
        [Switch] $RemoveSpecialChars,
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
        
        if ($RemoveSpecialChars){    ##remove any other special characters        
            
            $NewStr = $NewStr -replace '[^a-zA-Z0-9\s\"\.,?:(){}@/\\\-\+\[\]]', ''

            return $($NewStr -as [string])
        }
        
        return $($NewStr -as [string])
    }
    catch
    {
        Write-Error -Message $Error[0].Exception.Message
    }
}
