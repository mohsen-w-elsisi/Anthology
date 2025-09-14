# **Technical Specification: Implementing Highlight Rendering**

## **1\. Problem Statement**

The goal is to render persistent, saved text highlights within a read-it-later application's reader view. The primary challenge is that the article content is not a single text block but a flat system of independent "text nodes," each with its own rendering widget. A single text node can contain multiple paragraphs or just a single word, and highlights can span across these nodes or be fully contained within them.

## **2\. Current State**

The existing system has the following characteristics:

* **Text Structure:** The article content is composed of a List of "text nodes."  
* **Text Nodes:** Each text node is an object that contains a text field (a string).  
* **Rendering:** Each text node is passed to its own stateless or stateful rendering widget. This widget is responsible for displaying the text. Currently, the text is displayed using a single Text widget or TextSpan.  
* **Highlight Data:** Highlights are successfully saved to a database. A highlight is a simple object containing a start index and an end index, which also correspond to positions within the complete article text.

## **3\. Proposed Solution**

The rendering logic will be implemented within each text node's rendering widget. The widget will receive two primary objects as input: its own text node and an object containing all the highlights for the article. The widget will then iterate through the highlights and apply a yellow theme (or any other specified highlight theme) to the relevant parts of its text.

### **Core Logic (Algorithm)**

The rendering widget's build method will perform the following steps:

1. **Preparation:** The first step is to enrich the text node data structure. The article parser must be updated to include a start and end index on each text node, corresponding to its position within the complete, concatenated string of the entire article. These indices will be crucial for mapping highlights to the correct nodes.  
2. **Input:** The widget receives its text node and the highlights object. The highlights object will be an array of highlight data structures.  
3. **Highlight Detection:** The widget must check if its text node's overall index range (from text\_node.start to text\_node.end) overlaps with the index range of any highlight in the highlights object.  
4. **Recursive/Iterative Splitting:** If an overlap is detected, the widget must not render a single Text widget. Instead, it must build a list of TextSpan objects that make up the complete text of the node.  
5. **Span Generation:** The process to generate the TextSpan list will be as follows:  
   * Start with the full text of the node and the first highlight that overlaps.  
   * Create a TextSpan for the un-highlighted prefix of the text.  
   * Create a TextSpan for the highlighted substring, applying the highlight style.  
   * Recursively or iteratively repeat this process for the remaining un-highlighted text and any subsequent highlights that overlap with the text node. This is critical for handling multiple highlights within a single node.  
6. **Output:** The final output will be a single RichText widget that uses a TextSpan tree to display the text with the correct styling applied to highlighted portions.