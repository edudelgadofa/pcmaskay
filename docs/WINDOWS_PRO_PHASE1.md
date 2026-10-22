# Recoll Windows Pro — Phase 1 (candidate)

**Status:** integration work in progress; NOT a verified Windows release.

This branch adds a standalone CI candidate build that **refuses to package** when the Recoll Qt GUI or essential runtime files are absent.

## Goals
- Build Recoll/Qt 6/Xapian from this existing fork.
- Verify recoll.exe, recollindex.exe and recollq.exe were actually compiled.
- Stage Qt platform plugins, Poppler utilities, sample configuration and Recoll filters.
- Check Windows x64 PE signatures and essential staged components before installer compilation.
- Smoke-test indexing and searches against TXT, PDF, DOCX and XLSX.
- Produce an Inno Setup installer and portable ZIP **as unverified CI artifacts only**.
- Test a silent installation and uninstallation.

## Limitations
- An interactive clean Windows 10/11 GUI/VM test is still required before a public release.
- The Recoll document filters include Python scripts. A self-contained Python runtime, correct environment variables and additional document dependencies must be validated independently; having Python on a CI runner is not proof of offline end-user support.
- No semantic AI, OCR bundle, WinGet/Scoop public packages, or Windows signing is included.
- The upstream GUI CMake code can compile but runtime behavior must still be tested.

## Workflow
GitHub Actions → **Windows Pro candidate**. A push to the branch also runs this workflow.

Do not publish the generated installer as a production release unless the end-user dependency audit and a clean Windows GUI/VM verification are complete.

The original Recoll code, licensing and project identity remain intact. This is community Windows packaging work, not an official Recoll release.
