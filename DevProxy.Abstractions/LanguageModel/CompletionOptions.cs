// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.
// See the LICENSE file in the project root for more information.

using System.Text.Json.Serialization;

namespace DevProxy.Abstractions.LanguageModel;

public class CompletionOptions
{
    [JsonPropertyName("temperature")]
    public double? Temperature { get; set; }
    [JsonPropertyName("top_p")]
    public double? TopP { get; set; }
}