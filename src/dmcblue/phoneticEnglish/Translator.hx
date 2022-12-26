package dmcblue.phoneticEnglish;

import dmcblue.phoneticEnglish.Converter;
import dmcblue.phoneticEnglish.Configuration;
import dmcblue.phoneticEnglish.Configuration;

using StringTools;

typedef TextNode = {
	type:TextType,
	text:String
}

class Translator {
	private var configuration:Configuration;

	public function new(configuration:Configuration){
		this.configuration = configuration;
	}

	public function conversionPath(from: ScriptType, to: ScriptType): Array<ScriptType> {
		var intermediateSteps = switch from {
			case ScriptType.ARPA1:
				switch to {
					case ScriptType.ARPA2: [ScriptType.IPA];
					case ScriptType.GA: [ScriptType.IPA, ScriptType.ARPA2];
					case ScriptType.IPA: [];
					case ScriptType.PHONETIC: [ScriptType.IPA];
					case ScriptType.RP: null;
					default: null;
				};
			case ScriptType.ARPA2:
				switch to {
					case ScriptType.ARPA1: [ScriptType.IPA];
					case ScriptType.GA: [];
					case ScriptType.IPA: [];
					case ScriptType.PHONETIC: [ScriptType.IPA];
					case ScriptType.RP: null;
					default: null;
				};
			case ScriptType.GA:
				switch to {
					case ScriptType.ARPA1: [ScriptType.ARPA2, ScriptType.IPA];
					case ScriptType.ARPA2: [];
					case ScriptType.IPA: [ScriptType.ARPA2];
					case ScriptType.PHONETIC: [ScriptType.ARPA2, ScriptType.IPA];
					case ScriptType.RP: null;
					default: null;
				};
			case ScriptType.IPA:
				switch to {
					case ScriptType.ARPA1: [];
					case ScriptType.ARPA2: [];
					case ScriptType.GA: [ScriptType.ARPA2];
					case ScriptType.PHONETIC: [];
					case ScriptType.RP: null;
					default: null;
				};
			case ScriptType.PHONETIC:
				switch to {
					case ScriptType.ARPA1: [ScriptType.IPA];
					case ScriptType.ARPA2: [ScriptType.IPA];
					case ScriptType.GA: [ScriptType.ARPA2, ScriptType.IPA];
					case ScriptType.IPA: [];
					case ScriptType.RP: null;
					default: null;
				};
			case ScriptType.RP:
				switch to {
					case ScriptType.ARPA1: null;
					case ScriptType.ARPA2: null;
					case ScriptType.GA: null;
					case ScriptType.IPA: null;
					case ScriptType.PHONETIC: null;
					default: null;
				};
			default: null;
		}

		intermediateSteps.unshift(from);
		intermediateSteps.push(to);
		return intermediateSteps;
	}

	public function buildConverters():Map<ScriptType, Map<ScriptType, Converter>> {
		var converters:Map<ScriptType, Map<ScriptType, Converter>> = new Map();

		converters.set(ScriptType.ARPA1, new Map());
		converters.set(ScriptType.ARPA2, new Map());
		converters.set(ScriptType.GA, new Map());
		converters.set(ScriptType.IPA, new Map());
		converters.set(ScriptType.PHONETIC, new Map());
		converters.set(ScriptType.RP, new Map());

		var tsv = new Tsv([Application.TYPE_ARPA1, Application.TYPE_IPA]);
		tsv.load(this.configuration.arpa1Path);
		converters.get(ScriptType.ARPA1).set(ScriptType.IPA, Converter.fromTsv(tsv, Application.TYPE_ARPA1, Application.TYPE_IPA));
		converters.get(ScriptType.IPA).set(ScriptType.ARPA1, Converter.fromTsv(tsv, Application.TYPE_IPA, Application.TYPE_ARPA1));

		var tsv = new Tsv([Application.TYPE_ARPA2, Application.TYPE_IPA]);
		tsv.load(this.configuration.arpa2Path);
		converters.get(ScriptType.ARPA2).set(ScriptType.IPA, Converter.fromTsv(tsv, Application.TYPE_ARPA2, Application.TYPE_IPA));
		converters.get(ScriptType.IPA).set(ScriptType.ARPA2, Converter.fromTsv(tsv, Application.TYPE_IPA, Application.TYPE_ARPA2));

		var tsv = new Tsv([Application.TYPE_GA, Application.TYPE_ARPA2]);
		tsv.load(this.configuration.dictPath);
		converters.get(ScriptType.GA).set(ScriptType.ARPA2, Converter.fromTsv(tsv, Application.TYPE_GA, Application.TYPE_ARPA2));
		converters.get(ScriptType.ARPA2).set(ScriptType.GA, Converter.fromTsv(tsv, Application.TYPE_ARPA2, Application.TYPE_GA));

		var tsv = new Tsv([Application.TYPE_PHONETIC, Application.TYPE_IPA]);
		tsv.load(this.configuration.phonPath);
		converters.get(ScriptType.PHONETIC).set(ScriptType.ARPA1, Converter.fromTsv(tsv, Application.TYPE_PHONETIC, Application.TYPE_IPA));
		converters.get(ScriptType.IPA).set(ScriptType.PHONETIC, Converter.fromTsv(tsv, Application.TYPE_IPA, Application.TYPE_PHONETIC));


		return converters;
	}

	public function splitText(source:String): Array<TextNode> {
		var textNodes: Array<TextNode> = [];
		var whitespace = [" ", "\t", "\n"];
		var alpha:EReg = ~/[A-Z]+/i;
		var text = "";
		var type: TextType = null;
		var chars = source.split('');
		var i = 0;
		while(i < chars.length) {
			var t = chars[i];
			var thisType = alpha.match(t) ? TextType.TEXT : TextType.WHITESPACE;
			if (type == null) {
				type = thisType;
			} else if (thisType != type) {
				textNodes.push({
					type: type,
					text: text
				});
				type = thisType;
				text = "";
			}

			text += t;

			// contractions
			if ((chars[i+1] == "'" || chars[i+1] == "’") && alpha.match(chars[i+2])) {
				text += chars[i+1] + chars[i+2];
				i += 2;
			}
			i++;
		}

		if (text.length > 0) {
			textNodes.push({
				type: type,
				text: text
			});
		}

		return textNodes;
	}

	public function translate(text:String, from:ScriptType, to:ScriptType):String {
		var output:Array<String> = [];
		var converters = this.buildConverters();
		var steps = this.conversionPath(from, to);
		var parts = this.splitText(text);
		for (part in parts) {
			if(part.type == TextType.WHITESPACE) {
				output.push(part.text);
			} else {
				var trans = part.text.toLowerCase().replace('’', "'").split('');
				for(i in 1...steps.length) {
					var from = steps[i - 1];
					var to = steps[i];
					var converter = converters.get(from).get(to);
					if (from == ScriptType.GA) {
						var str = trans.join('');
						var t = converter.convert(str).split(' ');
						// if can't find word starting with negation (un), search by non-negation
						if (t.length == 1 && t[0] == Converter.NULL && str.substr(0, 2) == 'un') {
							t = converter.convert(str.substr(2)).split(' ');
							if (!(t.length == 1 && t[0] == Converter.NULL)) {
								t = ['ah', 'n'].concat(t);
							}
						}

						trans = t;
					} else {
						trans = converter.convertEach(trans);
					}
				}

				if(trans.join('') == "") {
					output.push('?');
				} else {
					for(str in trans) {
						output.push(str != null ? str : '?');
					}
				}
			}
		}

		return output.join('');
	}
}
