
# ==============================
##@ 📚 Documentation
# ==============================
ifndef __DOC_MK__
__DOC_MK__ := 1

# Path for Generated Make Targets Document
TARGET_README	:= README_make_targets.md

# Documentation
URL_PY_DOCS	:= "https://docs.python.org/3/index.html"
URL_TURTLE	:= "https://docs.python.org/3/library/turtle.html"
URL_DOCTEST	:= "https://docs.python.org/3/library/doctest.html"
URL_MOD_PY	:= "https://docs.python.org/3/py-modindex.html"
URL_PEP8	:= "https://peps.python.org/pep-0008/"

# Tutorials
URL_SWINNEN	:= "https://inforef.be/swi/python.htm"


# Git Repos


.PHONY: doc help-md

doc: ## Show documentation links
#	@clear
	@echo "Select documentation subject:"
	@echo "\n$(ORANGE)Documentation$(RESET)"
	@echo "  0. Python Docs"
	@echo "  1. turtle Docs"
	@echo "\n$(ORANGE)Tutorials$(RESET)"
# 	@echo "  10. "
	@echo "\n$(ORANGE)Useful Git Repositories$(RESET)"
# 	@echo "  100. "

	@read url_choice; \
	case $$url_choice in \
		0) CHOICE=$(URL_PY_DOCS);; \
		1) CHOICE=$(URL_TURTLE);; \
		*) $(call ERROR,Invalid choice,$$url_choice); exit 1;; \
	esac; \
	$(OPEN) $$CHOICE
#	@clear
	@$(call INFO,,Opening documentation...)


help-md: ## Generate markdown documentation for all Make targets
	@echo "\n# 📘 Makefile Targets" > $(TARGET_README); \
	awk ' \
		BEGIN { print "" } \
		/^##@/ { \
			gsub(/^##@ /, "", $$0); \
			print "\n## " $$0 \
		} \
		/^[a-zA-Z0-9\-_]+:.*##/ { \
			split($$0, parts, ":.*##"); \
			target=parts[1]; \
			desc=substr($$0, index($$0,"##")+2); \
			printf "- `%s`: %s\n", target, desc \
		} \
	' $(MAKEFILE_LIST) >> $(TARGET_README); \
	echo "\n📄 Generated at $$(date)" >> $(TARGET_README); \
	$(call SUCCESS,Docs,Markdown Makefile target index generated)

endif # __DOC_MK__
