import re
import sys

def words_from_file(filename):
    with open(filename, 'r') as word_list:
        return [s.strip() for s in word_list]

def capitalize(word, first, capitalize_no, capitalize_custom):
    for custom in capitalize_custom:
        if word.lower() == custom.lower(): return custom
    if not first:
        for no in capitalize_no:
            if word.lower() == no: return no
    return word[0].upper() + word[1:]

def make_pretty(str, aspect_ratio, punctuation, capitalize_no, capitalize_custom):
    max_line_len = int((aspect_ratio * len(str)) ** 0.5)
    words = str.split("_")

    # perform appropriate capitalization action
    for i, word in enumerate(words):
        words[i] = capitalize(word, i == 0, capitalize_no, capitalize_custom)

    # attach punctuation to last word
    words[-1] += punctuation

    lines = [words[0]]
    # insert line wraps
    for word in words[1:]:
        appended = lines[-1] + ' ' + word
        if (len(appended) <= max_line_len):
            lines[-1] = appended
        else:
            lines.append(word)
    # use the escape sequence instead of an actual newline character
    # because dot will replace it later
    return '\\n'.join(lines)

if __name__ == "__main__":
    capitalize_no = words_from_file('capitalize-no.txt')
    capitalize_custom = words_from_file('capitalize-custom.txt')

    for line in sys.stdin:
        line = line.rstrip()
        match = re.match(r'^[\s]*([\w]+)[\s]*\[([^\]]*)\]', line)
        if match:
            if 'DECIDE' in match.group(2):
                punctuation = '?'
            else:
                punctuation = ''

            label = make_pretty(match.group(1), float(sys.argv[1]), punctuation,
                    capitalize_no, capitalize_custom)

            line = re.sub('\]$',' label="' + label.replace('\\', r'\\') + '"]', line)
        print(line)
