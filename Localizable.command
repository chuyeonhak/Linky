# TEMP 파일 경로
TEMP_FILE="tempI18N.swift"

# Output 파일 경로
OUTPUT_FILE=Linky/Core/Sources/Util/Localize/I18N.swift

# JSON 파일 경로
JSON_FILE="Linky/Linky/Resources/Localize/Localizable.xcstrings"

# make TEMP_FILE
touch "$TEMP_FILE"

# make TEMP_FILE
touch "$TEMP_FILE"

{
    echo "public enum I18N {"
    jq -r '.strings | to_entries[] | "\(.key):\(.value.localizations.ko.stringUnit.value| @json | rtrimstr("\"") | ltrimstr("\""))"' "$JSON_FILE" |
    while IFS=":" read -r key value; do
	if [[ "$key" =~ "@" ]]; then
	    continue
	elif [[ "$value" =~ "\n" ]]; then
            modified_value=$(echo "$value" | tr '\n' ' ')
            echo "    /// ${modified_value}
	public static let "$key" = \"$key\".localized"
        else 
            echo "    /// ${value}
    public static let "$key" = \"$key\".localized"
        fi
    done
    
    echo "}"
} > "$TEMP_FILE"

cat "$TEMP_FILE" > "$OUTPUT_FILE"
rm "$TEMP_FILE"
