import { supabase } from '@/supabase'

export const perfilService = {
    async actualizarAvatar(file, userId) {
        // 1. Crear nombre único para la imagen
        const fileExt = file.name.split('.').pop()
        const filePath = `${userId}/avatar-${Date.now()}.${fileExt}`

        // 2. Subir a Supabase Storage (Bucket 'avatars')
        const { error: uploadError } = await supabase.storage
            .from('avatars')
            .upload(filePath, file, {
                upsert: true,
                contentType: file.type,
                cacheControl: '3600'
            })

        if (uploadError) throw uploadError

        // 3. Actualizar los metadatos guardando SOLAMENTE la ruta relativa
        const { error: updateError } = await supabase.auth.updateUser({
            data: { avatar_url: filePath } // Guardamos solo la ruta (ej: "1234/avatar-5678.jpg")
        })

        if (updateError) throw updateError

        // 4. Retornamos la ruta en lugar de la URL pública
        return filePath
    }
}