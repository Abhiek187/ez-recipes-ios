//
//  MultiPicker.swift
//  EZ Recipes
//
//  Created by Abhishek Chaudhuri on 10/19/26.
//

// Fork of https://github.com/toastersocks/MultiPicker/blob/main/Sources/MultiPicker/MultiPicker.swift to fix a Duo bug
import SwiftUI

public enum SelectionIndicatorPosition {
    case leading
    case trailing
}

public enum MultiPickerStyle {
    case navigationLink
    case inline
}

public enum ChoiceRepresentationStyle {
    case plainText
    case rich
    case custom(_ content: () -> (any View)?)
}

public extension View {
    @ViewBuilder
    func mpTag<Value: Hashable & Sendable>(_ value: Value) -> some View {
        self.containerValue(\.mpTag, value as (any Hashable & Sendable)?)
    }
}

extension View {
    public func mpPickerStyle(_ style: MultiPickerStyle) -> some View {
        environment(\.mpPickerStyle, style)
    }
}

extension ContainerValues {
    @Entry var mpTag: (any Hashable & Sendable)? = Int?.none
}

extension Subview {
    var mpTagValue: (any Hashable & Sendable)? {
        containerValues.mpTag
    }
}

extension EnvironmentValues {
    @Entry var mpPickerStyle: MultiPickerStyle = .inline
    @Entry var selectionIndicatorPosition: SelectionIndicatorPosition = .trailing
    @Entry var choiceRepresentationStyle: ChoiceRepresentationStyle = .plainText
}

public struct MultiPicker<Label: View, SelectionValue: Hashable, Content: View>: View {
    private var selection: SelectionBinding<SelectionValue>
    @ViewBuilder private var content: () -> Content
    private var label: Label
    private var title: LocalizedStringKey
    private var noneText = String(localized: "(None)")
    @Environment(\.mpPickerStyle) private var pickerStyle
    @Environment(\.selectionIndicatorPosition) private var selectionIndicatorPosition
    @Environment(\.choiceRepresentationStyle) private var choiceRepresentationStyle

    public var body: some View {
        NavigationLink {
                MultiPickerSelectionList<SelectionValue, Content>(selection: selection, indicatorPosition: selectionIndicatorPosition, content: content)
                // Adding text to a toolbar causes a hang on closed iPhone Duos due to the conflicting vertical layout
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
        } label: {
            LabeledContent {
                selectedOptions()
                    .accessibilityHidden(true)
            } label: {
                label
            }
        }
        .accessibilityValue(Text(text(forValue: selection)))
    }

    @ViewBuilder
    func selectedOptions() -> some View {
        Group {
            Text(text(forValue: selection))
        }
    }

    private func text(forValue: SelectionBinding<SelectionValue>) -> String {
        switch selection {
        case .single(let binding):
            String(describing: binding.wrappedValue)
        case .oneOrNone(let binding):
            "\(binding.wrappedValue.map { "\($0)" } ?? "\(noneText)")"
        case .multiple(let binding):
            binding.wrappedValue.map { String(describing: $0) }.formatted(.list(type: .and))
        }
    }

    public init(selection: Binding<Set<SelectionValue>>, @ViewBuilder content: @escaping () -> Content, @ViewBuilder label: () -> Label) {
        self.selection = SelectionBinding.multiple(selection)
        self.content = content
        self.label = label()
        self.title = ""
    }

    @_disfavoredOverload
    public init<S: StringProtocol>(_ title: S, selection: Binding<Set<SelectionValue>>, @ViewBuilder content: @escaping () -> Content) where Label == Text {
        self.selection = SelectionBinding.multiple(selection)
        self.content = content
        self.label = Text(title)
        self.title = LocalizedStringKey(String(title))
    }

    public init(_ titleKey: LocalizedStringKey, selection: Binding<Set<SelectionValue>>, @ViewBuilder content: @escaping () -> Content) where Label == Text {
        self.selection = SelectionBinding.multiple(selection)
        self.content = content
        self.label = Text(titleKey)
        self.title = titleKey
    }
}

enum SelectionBinding<SelectionValue: Hashable>: Equatable {
    case single(Binding<SelectionValue>)
    case oneOrNone(Binding<SelectionValue?>)
    case multiple(Binding<Set<SelectionValue>>)

    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.single(let l), .single(let r)): l.wrappedValue == r.wrappedValue
        case (.oneOrNone(let l), .oneOrNone(let r)): l.wrappedValue == r.wrappedValue
        case (.multiple(let l), .multiple(let r)): l.wrappedValue == r.wrappedValue
        default: false
        }
    }

    var isNone: Bool {
        switch self {
        case .oneOrNone(let binding) where binding.wrappedValue == nil:
            true
        case .multiple(let binding) where binding.wrappedValue.isEmpty:
            true
        default:
            false
        }
    }

    func isSelected(_ bound: SelectionValue) -> Bool {
        switch self {
        case let .single(binding):
            bound == binding.wrappedValue
        case let .oneOrNone(binding):
            bound == binding.wrappedValue
        case let .multiple(binding):
            binding.wrappedValue.contains(bound)
        }
    }

    func select(_ bound: SelectionValue) {
        switch self {
        case let .single(binding):
            guard isSelected(bound) == false else { return }

            binding.wrappedValue = bound
        case let .oneOrNone(binding):
            binding.wrappedValue = isSelected(bound) ? nil : bound
        case let .multiple(binding):
            if isSelected(bound) {
                binding.wrappedValue.remove(bound)
            } else {
                binding.wrappedValue.insert(bound)
            }
        }
    }
}

fileprivate struct MultiPickerSelectionList<SelectionValue: Hashable, Content: View>: View {
    private var selection: SelectionBinding<SelectionValue>
    @ViewBuilder private var content: Content
    @State private var selectionIndicatorPosition: SelectionIndicatorPosition

    var body: some View {
        List {
            ForEach(subviews: content) { child in
                let tag = child.mpTagValue.flatMap {
                    $0 as? SelectionValue
                }
                let paddedChild = child.padding(.vertical, 4)
                HStack(spacing: 4) {
                    if selectionIndicatorPosition == .trailing {
                        paddedChild
                            .padding(.horizontal)
                        Spacer()
                    }
                    checkmark(tag: tag)
                    if selectionIndicatorPosition == .leading {
                        paddedChild
                        Spacer()
                    }
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0))
                .contentShape(Rectangle())
                .accessibilityAddTraits(.isButton)
                .accessibilityValue(
                    tag.map {
                        Text(selection.isSelected($0) ? "Selected" : "")
                    } ?? Text("")
                )
                .onTapGesture {
                    tag.map { selection.select($0) }
                }
            }
        }
    }

    @ViewBuilder private func checkmark(tag: SelectionValue?) -> some View {
        Image(systemName: "checkmark")
            .resizable()
            .fixedSize()
            .font(.body)
            .fontWeight(.semibold)
            .padding(.horizontal, 10)
            .foregroundColor(.accentColor)
            .opacity(tag.map { selection.isSelected($0) ? 1 : 0 } ?? 0)
            .accessibility(hidden: true)
            .padding(.trailing, selectionIndicatorPosition == .trailing ? nil : 0)
    }

    fileprivate init(selection: SelectionBinding<SelectionValue>, indicatorPosition: SelectionIndicatorPosition = .trailing, @ViewBuilder content: () -> Content) {
        self.selection = selection
        self.content = content()
        self._selectionIndicatorPosition = State(initialValue: indicatorPosition)
    }
}
